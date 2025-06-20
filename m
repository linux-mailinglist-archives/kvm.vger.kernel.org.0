Return-Path: <kvm+bounces-50241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AD3CAE2696
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 01:52:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B1251BC729D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 23:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6605242D68;
	Fri, 20 Jun 2025 23:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AayouSvv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3353423956A;
	Fri, 20 Jun 2025 23:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750463528; cv=fail; b=PB+o5pDf6edLhnFMN3u099UvIA/BE+DaD2U5NLP7JSKeFwTMputdwVEO8XTfnaE85hrl/AhFRzvCs6zDzSUnOdMMNzHYj/Uiy5NsDeRRPW/+2oWNLw7tU20vbCxmbapESPynFub12U6CGqwFab88v3TSOmT7+ip77cNAzd3LP8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750463528; c=relaxed/simple;
	bh=jAzL9MpZkKv2hsbIxnRKHtOZUtES3ZJxSAbGIetmWHc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N+NDX4OSy0I+/Dt3g9YxmrnOUMkA9wf01XQrUl26alY/Fibo+c1b3HsMOe4skXthxMd/qfrULJo/W63kk57w3sM4XVll8dXIyOdqI2XFpjsVFAXkIFWzmwHw9lASQOWDrwgX6lJvnxwz69yD7h0RHB4CJh7vvVwRw/VSzh7lKoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AayouSvv; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750463526; x=1781999526;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jAzL9MpZkKv2hsbIxnRKHtOZUtES3ZJxSAbGIetmWHc=;
  b=AayouSvvE4/7G/8oZjMc7y8Yf/KFBQqx91EEGPTHo9X0MNcG7/xwFVEO
   bkkDNG/de3r5d25hw8LrWLMo7WjmxWEerjC0ukPTyD4XGc1Qb0KLZeEhn
   9rjcfw4Y+y4x+jm7cAUaHPvvNer8eFZONw5rAINHFq5AiKmT0mZ6eBVcA
   xakwj2XCa8VRO5F06+EH2rl/5VnkNxy8ty1F365YjNlzSiTvJPlId3Uw5
   DZ6ou/wr/4dcpC2mSJpJr73+I67/lZBiw+z7M7YC0JrTFJ36G98tQ1fUv
   tThD09Z9oniTrlAT3zEXxLOTiD7BkXxKAfXChGWZeH5XL63Mr6+EU58jx
   A==;
X-CSE-ConnectionGUID: nPqB94yKQN62KwBrZMEn2A==
X-CSE-MsgGUID: Wgk+wy0OSoyIZkC/yOCCEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="52616059"
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="52616059"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 16:52:05 -0700
X-CSE-ConnectionGUID: XZrOqj4RRJij+CKCbm7bmA==
X-CSE-MsgGUID: 6JFvhGvuTGadJXFEjwfBiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="151177966"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 16:52:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 20 Jun 2025 16:52:04 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 20 Jun 2025 16:52:04 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.62) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 20 Jun 2025 16:52:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bkYNxRG+NFrxYd5ZyG8bHqMdaAzLg6yDK4Fh2t4G33Lxdhtqxw9yVRPm49FG8So4Obkhn3h20H7mvyNbkoN8j2R2gl8SfPY7geXHzvuBE34ypm1maKyyZ7f0obpoisIwmXNedl1E3IjzN58nyD8AsrqYeN7XPenl+XB9Jkykidccpxbd/tOTpPApg4PfN87mvy+TEO1O0GxwX0qgzpfh5rKkCCakEbIQ5VSNdy9mcpT2Deiwdw2+7CI46p9PPE5xCuR6Fp628ac6RAbUx7YhgA8aWK/ghGG70ZYPW94MyvlfZbVW24cTfH02GIGfTQJV3ALY/HsU40UFv618jtPkUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jAzL9MpZkKv2hsbIxnRKHtOZUtES3ZJxSAbGIetmWHc=;
 b=E+zrkDrj7esQt1Uw4c7L8vzvL6YJX9AF3/T3k/AxREzvRSxNchixUokS9i/jhoOhf6G1ZAWab65pVh0jL2VRwk31vIqj1aCHOJXeMz4VWPH0TtbapXbRtZO5vigMLMqHAwzKj6qAF2/ndMewUzQuoRkxdcAsPGPEVX4ysbBdjsB4ywn2f33Vq+xpaF9fqau6eB6Bv7LqNCZVDaCX7UEZ0hTJ2MxVxz7ibCQHpGfPLIoz32wetEN4/vA3qATuTbvzpShINhhQoOkj3y7owVp1er7vzG7gxyiAc0DPI4M1mf8xmFf4tT0juFip8JWuiFiYUHUWzGTMyGg30PZC7MYUNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6306.namprd11.prod.outlook.com (2603:10b6:930:22::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Fri, 20 Jun
 2025 23:51:45 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.027; Fri, 20 Jun 2025
 23:51:45 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "liam.merwick@oracle.com" <liam.merwick@oracle.com>, "Kohler, Jon"
	<jon@nutanix.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Amit.Shah@amd.com" <Amit.Shah@amd.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2025.06.18 - Any topics?
Thread-Topic: [ANNOUNCE] PUCK Agenda - 2025.06.18 - Any topics?
Thread-Index: AQHb38r955+dRdW+wE6JhNGGRiXQQLQMvPcA
Date: Fri, 20 Jun 2025 23:51:45 +0000
Message-ID: <b9722d7f691f3aa32c4c725139a99ad49902aacb.camel@intel.com>
References: <20250617210100.514888-1-seanjc@google.com>
In-Reply-To: <20250617210100.514888-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6306:EE_
x-ms-office365-filtering-correlation-id: d526b35f-33d2-4ee2-3068-08ddb0556a3b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U3NDVnRRdnhUL0t4VFpQUzJUd3R4ais2SU1HQytQdERrRjlRVWsvZVRDUWFz?=
 =?utf-8?B?dFhEcXF5MHI3WGlBcDZFOUdkOGs2bkhDREFYcDFiOWRlRFY4NmdhdVhRWHly?=
 =?utf-8?B?ZE5mUG5pZXpHVnJrZDRKOFg5SFBTR2hLdmkweVdVQ0NQYnFKa3RsVDNnMlJC?=
 =?utf-8?B?SnpTeVlqMWxHR0cwbXJCWnZQaTlaR05FVHpoSlNvZUpGcGtzc2kvS2Jsc1p6?=
 =?utf-8?B?QWhBTExaSmdzZzhSNzRSZzRPcGpYZkFFTHJ4My9FdWxDOFR5L1ZuWjgyZHdL?=
 =?utf-8?B?WG40anFnNjBudXN0dldPbE5QMStWUjI0YjRSY1NnYy9vbGFrNk5VV0Y5MjJ6?=
 =?utf-8?B?WENlMEN4UVJLbHB0MlV4V2FTMkFYNkFxb0dDYlZ5cUszSFAvUDIxNnhNSmZw?=
 =?utf-8?B?WGVsU0tjR1E0cnViMkxoTmZJNWcwdE1JNmdkVWdJTGgxYXZaNnBxMzVQYXBB?=
 =?utf-8?B?QzBGeFNrSGU0RzhIdFpIMGxDUXE0dG45TWtQUXVONVEvVTBrRUNPL1FMNVhJ?=
 =?utf-8?B?MUlyZS84UTVFL2hNSFZQM2pEZ2NjdUlmWSsxSVk5eHNjM1N2clV2VWJ2c2VK?=
 =?utf-8?B?NmJ3S0FWc2p4bkNQb2U2dFplU1QzRlVnTkFVKytON0RYWDdZNS9lRUo4Mkxy?=
 =?utf-8?B?SHBCM013ZU1reDcrVnNhV0tTRHBVN1RRRXVweGgzNm5ubENnUWhraFlOK25E?=
 =?utf-8?B?SHFPNmRxNE9zNk1hMVJkSU9qZDBIbGdRTVRTMGxCQ1N3dnVMQWliTUVSTFFU?=
 =?utf-8?B?TXZxSUFPbnRxVVQzUWJwRkplQnFSQit4MXhVQW5vang4RlZjSlBDZytRNytI?=
 =?utf-8?B?RFNXY1hJdHlEUlI5alJ5Z3cwQ25zRUZmWDlFM0l1c2l0YXZjMG5nUUZkc0l0?=
 =?utf-8?B?OHJFU29kMi9lcHRZN0tINlBpWi83WXluY1FHcmZLVUh0aWcwMkVYUFVGY2Ft?=
 =?utf-8?B?TkR4RU1VRHNEOGRrT1BZemVBQTVSYW9rc3ZHdlJaeVNkQjBkOE5DQ2ZUK25n?=
 =?utf-8?B?WnpQdFArelJ1QU9OcWwwck5HZm5BeDgzaE5kb2dkRjIrSkhwVzU5NFkxcG5G?=
 =?utf-8?B?R210Z1JWcUdJOWRCRlJoRHo1T0NNT2ZDWVBscEFhVkc1bUlyVEUrZlNZdHlN?=
 =?utf-8?B?R2pQZE5vaEJwVks0VTZUUFh0Rzh0U1JITS9lSEl3UlJUQklmM3hhSmFlcUd6?=
 =?utf-8?B?T21CR3piMllwc0VOWTFzSEh2Z2dlZkxvUlFaOXY4SHREZ1NkUHd3SjcvK2V2?=
 =?utf-8?B?VFJqbzY4K2plWlFsMWQ4UGd2a1p5TUZEZVlJRy8yNjlPMGFscWhyUkUwYTBR?=
 =?utf-8?B?VWJ0RE16QVhOSzFHcXd5YzdoSFNRQjdpQ2NEN2pZQTR0MFZLQVpGb2JyTVMy?=
 =?utf-8?B?dFNDTm4zc25NVk1RRU5lYmU5Q1ErSVVoWm0zL2tVT1FYTjhaR3pQeTl4b2tp?=
 =?utf-8?B?Mms4WUNneFp3ZHcvOFRrTWdnQUdsS2pPeUNYbjFJL20waDY1eGwvZFF3VzQ1?=
 =?utf-8?B?WFNYV3k4Z0tWUktvTWhDSDYzWGk5a3FCVncwWnQ4RGtJdmlhaHVRUjRJMFd1?=
 =?utf-8?B?OU90SnM0WXl5WUh2N1VSZDd4RmlpV0dFWnQxV0QwOXU0ZXpBL3NzcXBzV2J1?=
 =?utf-8?B?WnQ2MG5GeGZ6Nm9nbVB1Z0lJakt2bHVKcjRjVjAybG9KT1F4L0VzanlsMFRq?=
 =?utf-8?B?amVJZllMMTZHWTBzSDN4bDd3U3FjSFNVWmZOYW4ycXI4TDRPamdKbjlwckJq?=
 =?utf-8?B?eXI0Z1dpd3FUbnY2NUQrR0dydlpYMmpXQlRNT0ZmSUhmUE1tTlhTbjM1K2FB?=
 =?utf-8?B?eWRjVGc5NlNaeTZCMmloZkM4OVBOaGZZVkpBOGsvZi9UQmNNNW1ReXNReWR0?=
 =?utf-8?B?UjArRlFRUE5UR2tIU1lYRnF2UG5MalZEMEgxMWZyWWZGSjJmZC9sNjYwTWwx?=
 =?utf-8?B?a1J5YmpPVm1WL3lobzB4ZE1OV2IrZG5WOGlnbFFJa1B5UlRabGQ2L0VsVGJ1?=
 =?utf-8?Q?24SE27Jh3m2yN5t4rGArEyaVVDaTMg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VEtmNlpWaHo5cXZVeVgwczlOaTZmK2QzTjc0YWZ3NmVQenFHWVdTN252azNY?=
 =?utf-8?B?eXk4WlRHLzluMTBmejFpWGlmSEJLYk5TSVRTaVUyeVlPTnZYWnR5Y3NUWGVz?=
 =?utf-8?B?T0hWOEZ6ZXdXVkVNL2VGeEpnUlZSdXEzRGFpNWtqZnd0azN5ZXd5eEV1THcz?=
 =?utf-8?B?UzVnbVlPTTdmaWtZQ0JjdHBQUGdCa0k3cHh4R3ZLVHBWdFlJc0ZhZGx3SWNT?=
 =?utf-8?B?TzAzS0hXNG1FSnBjc28rQ0NhaWNubUZ0Zk9Tbi9tYWhsVEhLOGVPcE9JNjJN?=
 =?utf-8?B?Q2IwMUxWb2VPbWlUUnoxWDNGZnQ3bHdVL09pT2VCNnBJRlZDYU5MWHFGYkJE?=
 =?utf-8?B?R0owME15c01IS2RMUWFzbEN4K1BBZDBJVks4Q0lHY1NTejNmVUJ3eXFpR1px?=
 =?utf-8?B?VkxyOEdBUUlOcHlUUHF2ZTNFb0k5d1FQTjJkdEdxTzN4cTlrM2lsRWJVT1h6?=
 =?utf-8?B?cjlNRUVUeVdXMWR1VU5jZytQaGVSUVpiNkUyRUs3OUozeVQwTEJ4VDlNV2dy?=
 =?utf-8?B?WTJtZWpyQ21pRXpQc2dsb3FGK2FTS0VnL0VIcVdIazdXZUo0eDF4WVZwV0tM?=
 =?utf-8?B?QjU5MHNBSEVsS1pMT1NrMEdqTFJ0UFlySmU0UWl6SEtOdlBmMEZMUFJGRjRp?=
 =?utf-8?B?M2gzMm9TSEhNbSt1c3MzckQ1ZTZzdFc1d1RzbFhta0RCbzFhbTlyNUFZcGlh?=
 =?utf-8?B?SVRhaXRUYXhVMzdwWmxCdnBTSlUvcFoxUkFqMklrWUJlM1VvVjlPVkhrWmx3?=
 =?utf-8?B?MldnakxTUXNTTDFVQTdTZnJYeHRJRWkrd0dKL0xpaGJkbERGeWlIQnVXN2Rk?=
 =?utf-8?B?dlZaYWc0RzVJUVBnN0p5UUFKL3o1WWhGTzVwQUt3ME05Um82eUFDWDhRdDVk?=
 =?utf-8?B?TFJBdS95elVOelFINGl2TkNhSE0yV2VteVpZL0hiV0k0anBHM0UxL0pKUFhv?=
 =?utf-8?B?S2xpTXNiSm8xb0xlSkZWRDN2V0lTcDd3MFc3bDZSbkJnN0hMUzRNdnVXSGF4?=
 =?utf-8?B?NmcwUnluOGhtWnFXRXhQQ0llYWtSTm5yMmpWN3MyWFhJRWp4Z2w1M0xVSzN2?=
 =?utf-8?B?ZDNqbUY5NEdVT2NJNlBGdHIvWStodGtZTDJQc08rejNzQnoxUFllY2NPdko4?=
 =?utf-8?B?L2N1K0dsOUUvUGxQTVhhV1ZzMWFGTklmdWJIRzRXeGhnTDF3c096Z2ZYZEJP?=
 =?utf-8?B?R0Exc0dsZ0NtYjhsTFNzQ2YxQWRQTDBUZlMwbXhneFFwN2RqSzNVZFlzeXVO?=
 =?utf-8?B?a2dsL2NzaVhQK21CWDQ1ajBGVCt3QTdlUVRkb0NIOXBzMkxBMXNLR2F3RjZ2?=
 =?utf-8?B?UGtkZUIvR2YrcG9MSG51b01IQ2E5NTZFMU5tTmZsbDJXTnJrT21uSVhQZGd5?=
 =?utf-8?B?ZWtyRHJaWFpHNzBITWxrY1NhcFFmZGFITFVrTThDelFsOThOaE1ObldIRnBJ?=
 =?utf-8?B?azdDd25XUUxLWGdmaTNreDZlNlpLMG82eVBYWW5kMkxXdDZNMC84THNCYnp4?=
 =?utf-8?B?a0x4RlhweGNiTFg2SXhkMGwrc3BOS2xMSVVKL0ZTb25JZGRDSmNVOXM3eXhE?=
 =?utf-8?B?MnJyR3d3NHRIMVNDaTJMSTNsTENJL2p4UUZjSUUyVW1XOWk5Ylc4c0NrTzIr?=
 =?utf-8?B?ZnM5T05NTzNIdHluRUc2eVU3N3E0TEpYMVVzazVxcVVhb1hsaGdpQU5wQWNa?=
 =?utf-8?B?bmhJRzdGTFRPSzYxMHNKTjJ2YWx6OVNUcEU4YjFFYy82M3FXTVQ0amR1Wk9J?=
 =?utf-8?B?NjFJSkt0RzZiVkJHZVRyVkdSbGhRNW5xeEdZc3RDMTlPVEFMc0lsa1pBYzJi?=
 =?utf-8?B?VTd6TWhFS0VrWXNFQlJwZDZDRWltU3pXazIrMUxzdWdhaGhnMEVneEJLcTNN?=
 =?utf-8?B?Vi9DbVNzWStqemV0ZUlBTzhnVnBUejJpaGFPQzVhdithcnRZb25jbDI0M3pV?=
 =?utf-8?B?MjlENFVLdXVtclJ0b29lRVZKTmhEd1laWncwRVZTdFVneGYrN2dCN01IUUlV?=
 =?utf-8?B?a3RvTnJXbS9KV3ZFYWhWTVhRVGZneWkzN28zYStnT1Y4cjZraTJHa1J4TUYr?=
 =?utf-8?B?cEx0djZ1aEd6VGpIa2IxYjBKQThVNTJGUDBOUVZKeW1rT1ppTi9pRjltNVNl?=
 =?utf-8?B?MTV3MjZZSE85RlZMcHFxeGZ5WEtKMDJyU2c3aGduazBIaWp5Mzh6K1JiNW95?=
 =?utf-8?B?Snc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F440471DA3024340B6DA2F2D5FD9B444@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d526b35f-33d2-4ee2-3068-08ddb0556a3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2025 23:51:45.6854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lNdocL/fyuKD9mU/Du4fMq6FfsE2HTh6FyRyj5zsL0t5JdhYunqADEQe6oekaXYGcr/uV2IvXlGVI3YpUsTSLVDpZ6RV/wLX7VZI3J5OnAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6306
X-OriginatorOrg: intel.com

VGhlcmUgYXJlIGFuIGluY3JlYXNpbmcgbnVtYmVyIG9mIFREWCBpbnRlcnNlY3RpbmcgcGF0Y2hz
ZXRzIGZseWluZyBhcm91bmQgb3INCmJlaW5nIGFsbHVkZWQgdG8uIEkgd2FzIHRoaW5raW5nIGl0
IGNvdWxkIGhlbHAgdG8gaGF2ZSBhIGRpc2N1c3Npb24gb24gaG93IHRoZXkNCmFyZSBhbGwgZ29p
bmcgdG8gY29tZSB0b2dldGhlci4NCiAtIFdoYXQgcGFydHMgZG8gd2Ugd2FudCB0byBkbyBpdGVy
YXRpdmVseSB2cyBjby1kZXNpZ25lZD8NCiAtIEhvdyB0byBhdm9pZCBkdXBsaWNhdGUgd29yayBs
aWtlIGRlYnVnZ2luZyBidWdzIGluIGRlcGVuZGVuY2llcyB0aGF0IGFyZQ0KYWxyZWFkeSBmaXhl
ZCBpbiBwcml2YXRlPw0KIC0gV2hhdCBvcmRlciB0byBkbyB0aGVtIHVwc3RyZWFtPw0KIC0gSG93
IHRvIGV2YWx1YXRlL3Rlc3QgTGludXggZ3Vlc3RzIGZvciBmZWF0dXJlcyB0aGF0IGRvbid0IGhh
dmUgcWVtdSBzdXBwb3J0Pw0KIC0gT3RoZXJzPw0KDQpPZiBjb3Vyc2Ugc29tZSBvZiB0aGVzZSBz
ZXJpZXMnIGFyZSBub3QgVERYIHNwZWNpZmljLiBCdXQgaW4gdGhlIFREWCBuZWNrIG9mIHRoZQ0K
d29vZHMsIHRoZXJlIHNlZW1zIHRvIGJlIGEgYml0IG9mIGEgZ2FwIGluIGNvbW1vbiB1bmRlcnN0
YW5kaW5nLg0KDQpJcyBhIFREWCBmb2N1c2VkIGRpc2N1c3Npb24gdXNlZnVsPyBDb3VsZCB3ZSBk
byBpdCBhcyBhIFBVQ0sgY2FsbCBhZ2VuZGEgaXRlbT8NCg0KVGhhbmtzLA0KDQpSaWNrDQo=

