Return-Path: <kvm+bounces-34538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1329DA00D4F
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 19:03:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B9841882ADF
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 18:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294F11FBCB7;
	Fri,  3 Jan 2025 18:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nsxaqomh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830AEBE4F;
	Fri,  3 Jan 2025 18:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735927387; cv=fail; b=Gr3Lt1izH3cQHZr+qALPH/bEwtQ00ZWfm/1XRIxaLCvJ9vz0tnj+VvJ4gBnl3avUZkbNP8sYt4SSKcf4r7fPUjNRgsoiu+gJTk00dJMelrNDIFH7AzagR5Tf0hEI6b4peXOC9bfdjYUihClICzk++VNV2agZVaUPlyHMHbJGzpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735927387; c=relaxed/simple;
	bh=g8Pd8SpTnOJVSatTMIz8mG8sFe3vYzNbX7r4LGxL7OI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G99uqVbGpTz0L1JGkTnEiCqqaBeiShVI+swXDY3AltiwgrIfGH+BwVklcmShTkYA+7CRL06FK/dpinwfgC7Jf/c8oim0dQtXygYhytncDEJrbbZGLMQEeC4sCzriR3i9MrIlyih1Dm5qFqqrep7imYiYGJnjyfUqSiBE1fJzJlU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nsxaqomh; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735927386; x=1767463386;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g8Pd8SpTnOJVSatTMIz8mG8sFe3vYzNbX7r4LGxL7OI=;
  b=nsxaqomh/Bw+lJiyTW5zdYI8mdj9zaAP39l9574FaWM0I4aYm6Xcly0G
   6woQIrDyDmkCOv0+a8YyXurT9FL9x44N7HAUHK+ngZMLCctX0kbzblxiy
   5OJGXLQNkgVLeMft/K0Kj3jhERj1kzjDCfzSExxQpMWUp9+DCBIklaqSw
   rWnugOW3x4UeOlSqUtduImF6FZexUoZxdKsjSBgz5F9yaT/WLUZayzcy/
   D2Jo7KU9+ggNqkMsCDryBE4iaaT4cO1Xn2Mx+jlJthbdcvxc//HPitcJW
   utsATgXnZ7+JSeIkhi8hfvv2ozuoDh10DBSecLm0TdRex7G0PgmnvDWlk
   Q==;
X-CSE-ConnectionGUID: 84Uq+nb3T0OTz92+6tv7WA==
X-CSE-MsgGUID: hTQ1iNt+RwGEeXf+EFKG7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11304"; a="36289362"
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="36289362"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2025 10:03:05 -0800
X-CSE-ConnectionGUID: qVarOKLKT4izBdTfnW5/EA==
X-CSE-MsgGUID: IchyC9ZlTKCimu7OeUnwFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="132695498"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jan 2025 10:03:05 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 3 Jan 2025 10:03:04 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 3 Jan 2025 10:03:04 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 3 Jan 2025 10:03:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cyyvOTHneOz1dGhOEtS3JfxVYy5XOaJ+4hvdhCXeUG00+hxb6lIytyEsjQjzMzNgw5qs08i4zAlCnMlyNCM/z/6xjMXYhHxXDj645t3bMUOQYjDAaWAE6Q/51zFDXl4/3vZn4kCnRFJPRxRJh+vSbOOmEAX0B4y5/PjQkL4JXP22qYO81poW5tQw0/BH3nEAYyNcktlWkaZNBihiFLTfB0YU5iP6cWx4QVG3T2AcNJQ6vDmWxzOmf002Qhuc9bhqPFgwtY5hoUYx54nTBYziQGabLAj3KksqBxcTxOEaZC0I6gksbi/j6GCP9rtM8Qytlbeb9Mq9pk2Xj+bXiv/UbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g8Pd8SpTnOJVSatTMIz8mG8sFe3vYzNbX7r4LGxL7OI=;
 b=yJT3sD1oX3hFLzxs50pW40kRUOEwAETFbSfXXF8mnD3j1nc26mM+7dUd9uJYaicC0xKnpuvtgbnVryDEtd0c3cNmABxVR5/YZSkpvI5hSaHVohqAHF0DAqMUu0/QyVRBQHyyUrdeS4G7HN38TbvhhOG2o1DZcjeckW1BLhUIYEqFyAuJKR3HYNvD+dLVo77IxhKC0YDCyhvBwuVm36Bm7RErYQgl8E5NgsdaOucJ3BJcHVoSxrl6jhwrHljjy5pUa7kmyhpKovm0QAks/W4Ct0UyH2OnLrK76Sk/Cj4pSYZdiCk3FzXHI3ya7xa1Rx5aTwIuiwUZypx5QVNaRuDnWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6307.namprd11.prod.outlook.com (2603:10b6:930:21::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.14; Fri, 3 Jan
 2025 18:02:31 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8314.013; Fri, 3 Jan 2025
 18:02:31 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 11/13] x86/virt/tdx: Add SEAMCALL wrappers for TD
 measurement of initial contents
Thread-Topic: [PATCH 11/13] x86/virt/tdx: Add SEAMCALL wrappers for TD
 measurement of initial contents
Thread-Index: AQHbXCHZxVZtZ0wMLkibbsfO5oamYrMFWwqA
Date: Fri, 3 Jan 2025 18:02:30 +0000
Message-ID: <a3813ab21be79ceed508293d22dd65fdacf9c096.camel@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
	 <20250101074959.412696-12-pbonzini@redhat.com>
In-Reply-To: <20250101074959.412696-12-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6307:EE_
x-ms-office365-filtering-correlation-id: 0a31fd0e-1b20-4def-9981-08dd2c20cacb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WFdESFVvSURrNHI4QUg5aU8weGtaUm9uK1ovR0phaDNQUW5TOXRxTFJPK3NJ?=
 =?utf-8?B?OHpZOVpBNUZBaVl3aWdtTzBaSHJoUGZPOG1LaWVLclhla3RjVlZtb3BJT04v?=
 =?utf-8?B?Qk5TSDZQQjNSSUIwV0kwQ3pTZFdYWTlLaHNTWCtUZHA0R25UblZseGs0ZWVL?=
 =?utf-8?B?WGhzRERRRzJZQnpWWnFDbXE2Tm5GR2hHRS93UHVEMDFYd3lGcmRCNmhLMW9H?=
 =?utf-8?B?TGpvQ1JoQWtRNGRVZWRZZnlMSUlraHNVNGRkcExQcUY2NHdTRGRBWWtRRFN3?=
 =?utf-8?B?OHp2UjY2QlczdlltcDIrVlhHZ1RPaGRyT0tQenJ5SGp3TWJBYnZya1JRSHhM?=
 =?utf-8?B?eE5CNFdkWGJsRkNFdTlULy9MZ0dCaTNIb0dGcllaYjAyZXYxalUwM3lkdGQ4?=
 =?utf-8?B?d09pMExYYVd4b25LKzhUbmJSRHcxK0ltTDNUeWNoV3hxVkkwYjFXQnNXaHZv?=
 =?utf-8?B?dW15c2pvOXc2b3pqZGJWdG9MMlFPVWtyUy9panpCVGZxbXltVnJNZzByVTlw?=
 =?utf-8?B?UFlZRFBEc1BNTDB2N2VHUGJ2UkVpL3VWS251TW11SG5QazAySEFKWWU4ZWFD?=
 =?utf-8?B?Zk5ZNGsvbEM5b1V2bU9WR2h2Q2lXNUVwcWRmaXFmRmZWb0l3RlFhVnZPay9C?=
 =?utf-8?B?SFVWdWo5OTFwYm4zcGpjaGd6dVBYbDVFMUxNV1h5YlNnQ2NjdlNwODFXNjBV?=
 =?utf-8?B?THhPMWpUZjQwWjN3ZkEvN056Yi9TYmRZTDgxbTdXcHcxRGs2NlJTeTlGeVVH?=
 =?utf-8?B?eXU3aHNaM2dqUVllNUswVjBDVE1nOW9zQmVub29uZmFUMkhZNGlyV01nc0xU?=
 =?utf-8?B?ZUNHeU45aFZUdm8xREFYblQzbHozTVZTV2xwQWdrcDhyYllOOHFCWnZsOGR3?=
 =?utf-8?B?WlF1SWZvSFd1c0JyallWUU9USWU5cEg3bzBBUktFd0xmbkFpUm9NN0ZiZUdI?=
 =?utf-8?B?dGZ4bTl1aFdPL01iaVYxVDNkQVVudENlVzBKb1hQOTluaGRoSUN0SWswR1Fp?=
 =?utf-8?B?VkQxTzhKSnBtQWN2Nll1bFgyVjZmeXJ2Uml4QkptejZUWFJGRnpxc3lDd202?=
 =?utf-8?B?UmZYem1Kc2hmbFdZaDFoZGJGUlFRQktMdXFTajhWYTZQMzBwWlZyOXUyUjJv?=
 =?utf-8?B?VG5DOXlQZU5ualRwVGR5OGNHNVZYdjcvS0FOdTR2MFZEY294SjdvY0FVTWU2?=
 =?utf-8?B?V2M5a0VCVm43STBwNEhhcDNaVFEwSGRRWERQR0d1VStTSXhVVE85a0pGU3Rs?=
 =?utf-8?B?amtEMkdGWnJyNE5aQ21FK0hYb0UxV3QwUUNSNXM1cis5enVuM0hxSnc0ejk5?=
 =?utf-8?B?SDQ3eFlnOFF1L2U3Q2JmSWJudldXT2VqUy9XRjRkb2RWTG1TazJVcWVlcE8w?=
 =?utf-8?B?MTduM3JjT3hSUlFQQkdYSnJSSWZuUVhYbjNlSis3ckZDYTNSTkMxQnE2Unhx?=
 =?utf-8?B?cWhuUjVnazRWNVlFeDRtaWQzZ2RYdkgxdzFsTU43TzJMcW5aemZNVGM4bFBX?=
 =?utf-8?B?SXJCaDBVL05UZ0o2cmJTWVpUZC9GZUVnRFZYU0tRNVQrR1hLRWpXNWJGdC9V?=
 =?utf-8?B?NVY2N2tBbWg5cStTSkJ6VFNuVGFGNUpsSDEwMGlTRlJlQkZWcG42cjdjeHNY?=
 =?utf-8?B?cCtISk9oWVVFd2tiY3BpN09UZ2FlWCtWZWltdEpLcFhmMkIvelloQWh6UWsy?=
 =?utf-8?B?LzF4NkozU2hwcy93a0RkL3JTU1d6R1pRL2ErNGRacHNxQmplYXRRdkx2MWxR?=
 =?utf-8?B?aHQzRm42cDEzeGZ3UmZiVFBKbklkSzI2c1ZzcDFLZ0tYQTc4QWtNUUFsTHo1?=
 =?utf-8?B?QklZaGZ1ZnNGMXNGZ0wrZG5WQ0U1WXh4Sm1Rb0kwL2UxaGRZUStjeDZYelZW?=
 =?utf-8?B?MCs0RjQ5TkxHTFNNeUYwWFAzYjBBWnB2dVhCTFIxaG5Mc1lTbml0M3NIK0Y3?=
 =?utf-8?Q?E8jlHnK7MmBguK3yGoGTqOkc5Z+NUlnF?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clk1bkN5bUQyYmlqdlhCWURYN2duamZWeEVaeG9ZWHJvM3d0NXdHQXhnQUhH?=
 =?utf-8?B?QjlsU3BSWkQvMjRZeU41WUpPalQ0bHllZEIreXZqa1lLd3ppVXNxSTNNS21r?=
 =?utf-8?B?alAvRE5EME9CcEhSWmxZZlFnU3RwYUJjeXFlYnBUekJrcFowSjM5bEJMSFpt?=
 =?utf-8?B?c3hhdGFoUzVFWkRFeFByOU0yaVlPeHBpMmdOS3N3M1JDMjJ2aUt0c1ZYRm9j?=
 =?utf-8?B?RERZNUFlL1FYVlU4WjVmL2s3NnFRa2ZBNVFvNGpXMGlkZWVXSGFZalZ1Uk9R?=
 =?utf-8?B?RU5mODRRRkRrbEZOeXlEQUxmT3pGSEtjWmNtaTErUzV1MWlMd0hoVjYwQVVJ?=
 =?utf-8?B?RGxjRnU0S3FHZXFGZCs2UzcwQ2FWdUFtTWNLeGllbHRvNktvenptOW1jeDhG?=
 =?utf-8?B?S3A1ZnpHTFRTU3E3aTE5VUtoWlZDSFlSVk5sbi9kTE13T3dTcmZBK1JJNUR2?=
 =?utf-8?B?NXpqdFp0VzMvTk9BZ2EzczlRL0ZvMUkxaTFHQU8wTGM5cU54dFVJYzlXT25C?=
 =?utf-8?B?bm90cS9kelphd01zOHd4YTRmRlN0VnRVMFRnaWJoNHlXTnR6QXBCeDBlRXZP?=
 =?utf-8?B?ZnFEZU9xVlEwVjZWb200V2VCTGVHejRjaERKZ0F5SzhTTllFeGRwQlJiMzl6?=
 =?utf-8?B?c3Y1bS81YnR2Y2pHOSt5djc5MThhVXpNeTh3Y2VnZGNaQ2VPUTVuUnBVYnBi?=
 =?utf-8?B?R2wwbFJwcm5GS3JWNnpEVk9CSlFWT0NwYi9yUDI0bis0S1FWZXUxVjZmbktO?=
 =?utf-8?B?SXQ5QkJ3V2dQa3A4MFcyRHFyWS8wVlh3V1ZiR1IxcnMwZUk5VkI5NXlRMm5E?=
 =?utf-8?B?VHc2YmNhVWVZbHU0akJpMEc4d2pTNlVqWnVlaU96c2tpMjEzdDJvZ3ZyQnhT?=
 =?utf-8?B?VjdwQ0czYStrV0diODhxT1hsSmhjK1g3ckN4R1FtQk1VNzd5Rm0vN1Y1QWda?=
 =?utf-8?B?NVZ5c3BISU5iWkJpcS9YSk5iaFBDc3Q1Um5xdGZsWi8vWVhaaVFOR0E5b2J4?=
 =?utf-8?B?TGdmTzYxZG5LYjZSb0hTbDFtT3BSSTkxOTErbmRjWE94RVV1bFFlcVpzTzh4?=
 =?utf-8?B?V2RSZjh3REhCcGpQTStGcWZQRlZud24rRkVlOEJISm9zWXZwV1QrMWxlZjdk?=
 =?utf-8?B?UzZvUUN6MmtYMnprMmZWMERYZldsV3FDdlJma0hKeXl4VHFwTXNwbytFMmJt?=
 =?utf-8?B?Mjl6c0h1SDJMRmtTREZBVHhmNW9OK3Uva1o2L1MxVkgxMDFNcVcySVpvTWI1?=
 =?utf-8?B?ckdRK2tHL2xIV0RqVTY5eitrbU80R3QvM3QvK0VEVXZTTEJlcnErd3ltZmJl?=
 =?utf-8?B?VXJLbHJQcS9DVU5nV05qTUg3RjFiVm9qVlpPSkFGSzdhZXAzNTAxdUdyR3NZ?=
 =?utf-8?B?ZTgzTnlEdXR0NEtxamZER3VqQUtQQnBKaEs4QVlPL3htSTRMOTZVdkoxZS8v?=
 =?utf-8?B?Q1pwcVo0dHo2SitZQ0EzbTVHR1FKSmVtNDVtWWdKWDN6VFY4OTh0M1FmbHh1?=
 =?utf-8?B?djNoN1dNRmpYTkNDVklZOEdJWkdXakg1ZEtwTk9yaFBWV3I2eHRvQnRLWXBs?=
 =?utf-8?B?eXdGZUsrYnpOY1hwaXBEVXhiTlVVSHR5dlUwbE9aZkt6NWVwcXNUZjRiNlZB?=
 =?utf-8?B?dkgvZ1UvanpBUjgyRzhZNHVoRFNtMGhIM2pobE93UEwzdUtPSHNNR290NjlN?=
 =?utf-8?B?S2NEMFlMRzRvdXpRUC9iNSszdDBrMjhDK1lGOW4rVXVXNjBRRUt4ZzM0NURS?=
 =?utf-8?B?QkVRVlEvTm1vRzBGQXJLMVpCaWE4em9uRTU0ZXZ1Tk9WNmdPWnFVRllTQXhD?=
 =?utf-8?B?UldlblhDY2UzYmxsODBYcDVBUk5rM1Ayc3Fub3k0S3BrcW5GdnVxMi9iL0pk?=
 =?utf-8?B?elVpdkUrQmJZdjVYZFdtSkJZMkVTYVNDNnV4R0NDU2xwSjZQSzU5bldVTnB5?=
 =?utf-8?B?aWRhanJkUW4xQ1JiZnpTbHFrOUkydjZUSTBia244TVNGaHI4cStWWEcxSWNs?=
 =?utf-8?B?eVh0aSsrZ0ZRaDFUUG9HNHd4cXp6aXVNYnRQWG9sNGVONVZURXRpbjhvbjlr?=
 =?utf-8?B?Y25oZTRyaitEUWNoelpSSTRpUWFWU2ZaWm5UZjJXdXdIWU1YakxZM1JOT0pQ?=
 =?utf-8?B?ZmtZcG9SOS80eDAwd0tlVk5CNUNqS3FkUmRPTTNsaFF5SVdGUW5pMkcrelNQ?=
 =?utf-8?B?QlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <26B54E597B6A7845B35E66ACC7017DE0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a31fd0e-1b20-4def-9981-08dd2c20cacb
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2025 18:02:30.8895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DXu3XlCvsMxPAjVefiG/CQz3B+4xiEgPBEOv8K3Kvj/8NZaf+0OkfcA+ArX9kNlfgwWRXQnDEEgf9RvfqpaSK+YR5MM8a3lPGT8gZIj1JBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6307
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAxLTAxIGF0IDAyOjQ5IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBGcm9tOiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiANCj4g
VGhlIFREWCBtb2R1bGUgbWVhc3VyZXMgdGhlIFREIGR1cmluZyB0aGUgYnVpbGQgcHJvY2VzcyBh
bmQgc2F2ZXMgdGhlDQo+IG1lYXN1cmVtZW50IGluIFREQ1MuTVJURCB0byBmYWNpbGl0YXRlIFRE
IGF0dGVzdGF0aW9uIG9mIHRoZSBpbml0aWFsDQo+IGNvbnRlbnRzIG9mIHRoZSBURC4gV3JhcCB0
aGUgU0VBTUNBTEwgVERILk1SLkVYVEVORCB3aXRoIHRkaF9tcl9leHRlbmQoKQ0KPiBhbmQgVERI
Lk1SLkZJTkFMSVpFIHdpdGggdGRoX21yX2ZpbmFsaXplKCkgdG8gZW5hYmxlIHRoZSBob3N0IGtl
cm5lbCB0bw0KPiBhc3Npc3QgdGhlIFREWCBtb2R1bGUgaW4gcGVyZm9ybWluZyB0aGUgbWVhc3Vy
ZW1lbnQuDQo+IA0KPiBUaGUgbWVhc3VyZW1lbnQgaW4gVERDUy5NUlREIGlzIGEgU0hBLTM4NCBk
aWdlc3Qgb2YgdGhlIGJ1aWxkIHByb2Nlc3MuDQo+IFNFQU1DQUxMcyBUREguTU5HLklOSVQgYW5k
IFRESC5NRU0uUEFHRS5BREQgaW5pdGlhbGl6ZSBhbmQgY29udHJpYnV0ZSB0bw0KPiB0aGUgTVJU
RCBkaWdlc3QgY2FsY3VsYXRpb24uDQo+IA0KPiBUaGUgY2FsbGVyIG9mIHRkaF9tcl9leHRlbmQo
KSBzaG91bGQgYnJlYWsgdGhlIFREIHByaXZhdGUgcGFnZSBpbnRvIGNodW5rcw0KPiBvZiBzaXpl
IFREWF9FWFRFTkRNUl9DSFVOS1NJWkUgYW5kIGludm9rZSB0ZGhfbXJfZXh0ZW5kKCkgdG8gYWRk
IHRoZSBwYWdlDQo+IGNvbnRlbnQgaW50byB0aGUgZGlnZXN0IGNhbGN1bGF0aW9uLiBGYWlsdXJl
cyBhcmUgcG9zc2libGUgd2l0aA0KPiBUREguTVIuRVhURU5EIChlLmcuLCBkdWUgdG8gU0VQVCB3
YWxraW5nKS4gVGhlIGNhbGxlciBvZiB0ZGhfbXJfZXh0ZW5kKCkNCj4gY2FuIGNoZWNrIHRoZSBm
dW5jdGlvbiByZXR1cm4gdmFsdWUgYW5kIHJldHJpZXZlIGV4dGVuZGVkIGVycm9yIGluZm9ybWF0
aW9uDQo+IGZyb20gdGhlIGZ1bmN0aW9uIG91dHB1dCBwYXJhbWV0ZXJzLg0KPiANCj4gQ2FsbGlu
ZyB0ZGhfbXJfZmluYWxpemUoKSBjb21wbGV0ZXMgdGhlIG1lYXN1cmVtZW50LiBUaGUgVERYIG1v
ZHVsZSB0aGVuDQo+IHR1cm5zIHRoZSBURCBpbnRvIHRoZSBydW5uYWJsZSBzdGF0ZS4gRnVydGhl
ciBUREguTUVNLlBBR0UuQUREIGFuZA0KPiBUREguTVIuRVhURU5EIGNhbGxzIHdpbGwgZmFpbC4N
Cj4gDQo+IFRESC5NUi5GSU5BTElaRSBtYXkgZmFpbCBkdWUgdG8gZXJyb3JzIHN1Y2ggYXMgdGhl
IFREIGhhdmluZyBubyB2Q1BVcyBvcg0KPiBjb250ZW50aW9ucy4gQ2hlY2sgZnVuY3Rpb24gcmV0
dXJuIHZhbHVlIHdoZW4gY2FsbGluZyB0ZGhfbXJfZmluYWxpemUoKSB0bw0KPiBkZXRlcm1pbmUg
dGhlIGV4YWN0IHJlYXNvbiBmb3IgZmFpbHVyZS4gVGFrZSBwcm9wZXIgbG9ja3Mgb24gdGhlIGNh
bGxlcidzDQo+IHNpZGUgdG8gYXZvaWQgY29udGVudGlvbiBmYWlsdXJlcywgb3IgaGFuZGxlIHRo
ZSBCVVNZIGVycm9yIGluIHNwZWNpZmljDQo+IHdheXMgKGUuZy4sIHJldHJ5KS4gUmV0dXJuIHRo
ZSBTRUFNQ0FMTCBlcnJvciBjb2RlIGRpcmVjdGx5IHRvIHRoZSBjYWxsZXIuDQo+IERvIG5vdCBh
dHRlbXB0IHRvIGhhbmRsZSBpdCBpbiB0aGUgY29yZSBrZXJuZWwuDQo+IA0KPiBbS2FpOiBTd2l0
Y2hlZCBmcm9tIGdlbmVyaWMgc2VhbWNhbGwgZXhwb3J0XQ0KPiBbWWFuOiBSZS13cm90ZSB0aGUg
Y2hhbmdlbG9nXQ0KPiBDby1kZXZlbG9wZWQtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4u
ai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0
b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYt
Ynk6IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IFNpZ25lZC1v
ZmYtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTog
UmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0KPiBTaWduZWQtb2Zm
LWJ5OiBZYW4gWmhhbyA8eWFuLnkuemhhb0BpbnRlbC5jb20+DQo+IE1lc3NhZ2UtSUQ6IDwyMDI0
MTExMjA3MzcwOS4yMjE3MS0xLXlhbi55LnpoYW9AaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5
OiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2
L2luY2x1ZGUvYXNtL3RkeC5oICB8ICAyICsrDQo+ICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4
LmMgfCAyNyArKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gIGFyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguaCB8ICAyICsrDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDMxIGluc2VydGlvbnMoKykN
Cj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaCBiL2FyY2gveDg2
L2luY2x1ZGUvYXNtL3RkeC5oDQo+IGluZGV4IDc0OTM4ZjcyNTQ4MS4uNjk4MWEzZDc1ZWIyIDEw
MDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiArKysgYi9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiBAQCAtMTQ3LDYgKzE0Nyw4IEBAIHU2NCB0ZGhfbW5nX2tl
eV9jb25maWcoc3RydWN0IHRkeF90ZCAqdGQpOw0KPiAgdTY0IHRkaF9tbmdfY3JlYXRlKHN0cnVj
dCB0ZHhfdGQgKnRkLCB1NjQgaGtpZCk7DQo+ICB1NjQgdGRoX3ZwX2NyZWF0ZShzdHJ1Y3QgdGR4
X3RkICp0ZCwgc3RydWN0IHRkeF92cCAqdnApOw0KPiAgdTY0IHRkaF9tbmdfcmQoc3RydWN0IHRk
eF90ZCAqdGQsIHU2NCBmaWVsZCwgdTY0ICpkYXRhKTsNCj4gK3U2NCB0ZGhfbXJfZXh0ZW5kKHN0
cnVjdCB0ZHhfdGQgKnRkLCB1NjQgZ3BhLCB1NjQgKnJjeCwgdTY0ICpyZHgpOw0KPiArdTY0IHRk
aF9tcl9maW5hbGl6ZShzdHJ1Y3QgdGR4X3RkICp0ZCk7DQo+ICB1NjQgdGRoX3ZwX2ZsdXNoKHN0
cnVjdCB0ZHhfdnAgKnZwKTsNCj4gIHU2NCB0ZGhfbW5nX3ZwZmx1c2hkb25lKHN0cnVjdCB0ZHhf
dGQgKnRkKTsNCj4gIHU2NCB0ZGhfbW5nX2tleV9mcmVlaWQoc3RydWN0IHRkeF90ZCAqdGQpOw0K
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYvdmly
dC92bXgvdGR4L3RkeC5jDQo+IGluZGV4IGNkZTU1ZTliMzI4MC4uODRmZTViYzc5NDM0IDEwMDY0
NA0KPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gKysrIGIvYXJjaC94ODYv
dmlydC92bXgvdGR4L3RkeC5jDQo+IEBAIC0xNjI5LDYgKzE2MjksMzMgQEAgdTY0IHRkaF9tbmdf
cmQoc3RydWN0IHRkeF90ZCAqdGQsIHU2NCBmaWVsZCwgdTY0ICpkYXRhKQ0KPiAgfQ0KPiAgRVhQ
T1JUX1NZTUJPTF9HUEwodGRoX21uZ19yZCk7DQo+ICANCj4gK3U2NCB0ZGhfbXJfZXh0ZW5kKHN0
cnVjdCB0ZHhfdGQgKnRkLCB1NjQgZ3BhLCB1NjQgKnJjeCwgdTY0ICpyZHgpDQoNCmdwYSBzaG91
bGQgYmUgdHlwZSBncGFfdCB0byBhdm9pZCBiYXJlIHU2NCB0eXBlcy4NCg0KPiArew0KPiArCXN0
cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgYXJncyA9IHsNCj4gKwkJLnJjeCA9IGdwYSwNCj4gKwkJLnJk
eCA9IHRkeF90ZHJfcGEodGQpLA0KPiArCX07DQo+ICsJdTY0IHJldDsNCj4gKw0KPiArCXJldCA9
IHNlYW1jYWxsX3JldChUREhfTVJfRVhURU5ELCAmYXJncyk7DQo+ICsNCj4gKwkqcmN4ID0gYXJn
cy5yY3g7DQo+ICsJKnJkeCA9IGFyZ3MucmR4Ow0KDQpDb3VsZCBiZSBleHRlbmRlZF9lcnIxLzIu
DQoNCj4gKw0KPiArCXJldHVybiByZXQ7DQo+ICt9DQo+ICtFWFBPUlRfU1lNQk9MX0dQTCh0ZGhf
bXJfZXh0ZW5kKTsNCj4gKw0KPiArdTY0IHRkaF9tcl9maW5hbGl6ZShzdHJ1Y3QgdGR4X3RkICp0
ZCkNCj4gK3sNCj4gKwlzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzIGFyZ3MgPSB7DQo+ICsJCS5yY3gg
PSB0ZHhfdGRyX3BhKHRkKSwNCj4gKwl9Ow0KPiArDQo+ICsJcmV0dXJuIHNlYW1jYWxsKFRESF9N
Ul9GSU5BTElaRSwgJmFyZ3MpOw0KPiArfQ0KPiArRVhQT1JUX1NZTUJPTF9HUEwodGRoX21yX2Zp
bmFsaXplKTsNCj4gKw0KPiAgdTY0IHRkaF92cF9mbHVzaChzdHJ1Y3QgdGR4X3ZwICp2cCkNCj4g
IHsNCj4gIAlzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzIGFyZ3MgPSB7DQo+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmggYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmgN
Cj4gaW5kZXggZDQ5Y2RkOWIwNTc3Li5hMWUzNDc3M2JhYjcgMTAwNjQ0DQo+IC0tLSBhL2FyY2gv
eDg2L3ZpcnQvdm14L3RkeC90ZHguaA0KPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4
LmgNCj4gQEAgLTI0LDYgKzI0LDggQEANCj4gICNkZWZpbmUgVERIX01OR19LRVlfQ09ORklHCQk4
DQo+ICAjZGVmaW5lIFRESF9NTkdfQ1JFQVRFCQkJOQ0KPiAgI2RlZmluZSBUREhfTU5HX1JECQkJ
MTENCj4gKyNkZWZpbmUgVERIX01SX0VYVEVORAkJCTE2DQo+ICsjZGVmaW5lIFRESF9NUl9GSU5B
TElaRQkJCTE3DQo+ICAjZGVmaW5lIFRESF9WUF9GTFVTSAkJCTE4DQo+ICAjZGVmaW5lIFRESF9N
TkdfVlBGTFVTSERPTkUJCTE5DQo+ICAjZGVmaW5lIFRESF9WUF9DUkVBVEUJCQkxMA0KDQo=

