Return-Path: <kvm+bounces-22283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED3AD93CD66
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 07:02:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B39C9282A82
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 05:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2C22A1C0;
	Fri, 26 Jul 2024 05:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JTQtz3+f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669BF816
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 05:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721970153; cv=fail; b=RehBx8wJMGnQWE+JQ2dosuCPpAZPxG807NXpGXwGgdYBJyOqnmuxyJWrkJAu1jbPDul7C8Y9FHg8rewjRLhY0qcC1eReVLBdRWKAi++unmJnPhEqDtwJjU2nldi231KbX0a5VZjeCsHxnAjM7ozJ9MC1SJnQnx0yxNHDQKruNIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721970153; c=relaxed/simple;
	bh=nMt0qja8n8BdN4rThUxlgciMAoh+agjwfv5Zf7Breto=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Cm8AKzYrXakaDD+m5f6br0UsGv+t4DIfzYHE/iq2+97q6dyyOKcDwA8+AH/q8pWAavw7HgNqahtTR0fOCXmJ1EKUGajpF2Xi87MdPq/t90mtrdjmtDgwg+D3nMJvv4TUlkcU0rEqpxjvY5/QxirHGk57Nry8xnEdMpgVnyvs+OU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JTQtz3+f; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721970152; x=1753506152;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nMt0qja8n8BdN4rThUxlgciMAoh+agjwfv5Zf7Breto=;
  b=JTQtz3+fIoHZy3YG7ak7sRF6AyeyCSHphi2Xy01HrTQWSC3/SbjPz6k+
   7PRGQMaIYeQW46tYb/PWS30nMsbME8hXREx+FRzoSzDs5kar/L9LPFEZT
   QhkUcaXtrJ4vq/56hqe/Q0LDAhSbzoELOUwKOR4xlj6FCR8b2SURYRkYq
   KJgLIsjVWe7acvY1b2BtRUIHZpYp+wZvVO0f4K8E/tJQy+GiqcMdWWwlc
   uEpeVYeB52gR6EuVZuAsirKEv/kgeQUCGuL2kpGoX0HBbNWz9X5+CvXLN
   KpuXqEAVrDiymd3Pldvc2f13OSvwYdO6CepQvZTaRQ3rDgHwMbJdTRRZ6
   w==;
X-CSE-ConnectionGUID: vUlJ8SnITyi0TyOCN6rDlQ==
X-CSE-MsgGUID: 3Q5d3RG/SVSeZu3ZAdciMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11144"; a="19874048"
X-IronPort-AV: E=Sophos;i="6.09,238,1716274800"; 
   d="scan'208";a="19874048"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 22:02:31 -0700
X-CSE-ConnectionGUID: vRz0+o/mQjOV2VpG+uOb0Q==
X-CSE-MsgGUID: CEvGfjEvRjaavKI9m3u1vA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,238,1716274800"; 
   d="scan'208";a="53167815"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jul 2024 22:02:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 25 Jul 2024 22:02:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 25 Jul 2024 22:02:30 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 25 Jul 2024 22:02:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OYUNLP0P3tc3NDcleveT8sVhAJGPq6TFm0TtEyX6xVAM3G8TIaJ+GZ/i37dt315K7iiioDYxgZdpIf296xphd8uGvts7ot2g1NyLBnklkwWXerV3V3B5vk5lpJdWcuyk99kPS95x5QTDFFDWQ5mBqsgTt7BbX7lpBP7tTdQ+V+lCJZbYWONj46UMYEfBlZLEm83bsHgspqp6L/VrsGKX9m0pJWlBGCj+vT4cE+3Gxw00/9QIIt9Z3SGCXd5fUpSDtMSJk/6EXCLusoqhwTAuntGv0w0pUKiDKrF5R7BWgU5ucPfo7JBOomLN+Rm+WUxUCQDufiRzGswsLCl9vVSM7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nMt0qja8n8BdN4rThUxlgciMAoh+agjwfv5Zf7Breto=;
 b=N4wpL+nm9F+jM31aghaXiifyCqBOWZGJbs3JC5GCNg8Gsu6XttJHUYGA/HRghfxci5CevESwCcgMJNDI6PzbLcP7va8ByQGVCvTTCCFbMxY0xNP/0RiAj22OVTjjNEVJNY5epxz+bv+GB4ZSkUrPrskn2fQdbJ6T6QG5n5qyPDQIv7WskouNa/itiNve0lby+jOhg7X1Gk/0B7vOApCjHe8x16CRc/+9IT8np6NQfL5WKDS90M07x60/81aCG/zdq/pz+kmgEwujOLz5WM8moAK91l2N5ISfbskZPtkE+OCoAcQChTLxfrr7MImkCrqHdiHdKolnVv8Gke4kPYMz+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5308.namprd11.prod.outlook.com (2603:10b6:408:119::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.28; Fri, 26 Jul
 2024 05:02:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 05:02:27 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: David Hildenbrand <david@redhat.com>, "Qiang, Chenyi"
	<chenyi.qiang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu
	<peterx@redhat.com>, =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Wang, Wei W"
	<wei.w.wang@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>, "Gao, Chao"
	<chao.gao@intel.com>, "Wu, Hao" <hao.wu@intel.com>, "Xu, Yilun"
	<yilun.xu@intel.com>
Subject: RE: [RFC PATCH 0/6] Enable shared device assignment
Thread-Topic: [RFC PATCH 0/6] Enable shared device assignment
Thread-Index: AQHa3mN597jLlfyiLkeIEfkfQdf4R7IHekYAgADvbcA=
Date: Fri, 26 Jul 2024 05:02:27 +0000
Message-ID: <BN9PR11MB527635939C0A2A0763E326A58CB42@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
 <ace9bb98-1415-460f-b8f5-e50607fbce20@redhat.com>
In-Reply-To: <ace9bb98-1415-460f-b8f5-e50607fbce20@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5308:EE_
x-ms-office365-filtering-correlation-id: 68ca492f-4f82-4d0e-2426-08dcad30255a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UFlMNzZWVU9vanpJSUQ2NnZ1clo5SkNWOGVTU3hUYUFsY2x6OVMzNGJrOTgx?=
 =?utf-8?B?SEhMdHBjcENGbkE3dW5MWDgzQVg4cW9QNmhEU2w1S3g4eFJwemhGQWIyUWp1?=
 =?utf-8?B?WnN3cmFVMThPWmRGRmQ5Ui94aHhnR20wbFFtZTFSdEJTTExQcVExNVJocTdo?=
 =?utf-8?B?N3pXKzQ4U1IxZVdWbFAzNmJpeEJHdTM0V3NuN2VTRm53TkNJK2dvczNxdit6?=
 =?utf-8?B?NjhZUU1ocUxRbE1ONWhaRzhyM2VOUDhsNjB3Qy9zUHBzSmVnY1J1ZFJja05K?=
 =?utf-8?B?V2ZCQzM1MGlHY3RsZ2RDanlUZTdvUEt1VVpMSzlVWjNkVUpZbEhsRFYwS1dZ?=
 =?utf-8?B?aTF2R1hwYnBLdFZCNnM3V3R2NWNiZ1QvUHBFZFZ0ckh6OG54WnIwRXFlV1M3?=
 =?utf-8?B?ai9UbkpHa2pubkxQa1E4NHMzcStWTUtkZm5QMXp6RU1WRW56V2JGZHZCRXVu?=
 =?utf-8?B?Y0pkZndsVUtYQlZhSjV1V3VlWWtVa1NjT1AzVkVyVU5tZHpGdHZtVWdybmdX?=
 =?utf-8?B?d0M5czFwVjRFN1c0ZTJ0TUxKL1AvSUp1NzMzQmk3dnlxNHlNdjZmT2lqclZR?=
 =?utf-8?B?L09pOXlHSlRmY2dSVEJncUFlb3FZalpYZHAxa05MMW1VZlh4a2lzb3ZpdEFk?=
 =?utf-8?B?U0ZyOWNrVmFKcFJodTNkK2RHcG52NjArdU16dUVLMy9CbDJOaFo0YTllZ3Nm?=
 =?utf-8?B?N3Ryak9Ja3ZEYnNnUklZTjlkK2d6RzN0emdWVExtc0ZmT3RLSlcweWdTUUgr?=
 =?utf-8?B?UWNmS2h3UldDVGlyV2VBN2NsYmZIMGdVZFBPODFldWV5bW9FSlh6ZDJTWDVR?=
 =?utf-8?B?U2tES0EyQnhmUzFIN05tVzMrb1R2YzJUYWZYdlpZeUs2UWRRcFhIakZucG5L?=
 =?utf-8?B?bDFqTHA4RExEcEI4RlovTnlLMjRXaEFBM0xuM29SdXZMM08vN1hpR2tYVjRQ?=
 =?utf-8?B?TllKd2ZUVGdkWmJGUmZRSVFnSktYeVRiNXZQcmpyTVNQa05TU1JkM0JmQVVn?=
 =?utf-8?B?cmJ1VG1mK2hVZGFPckgzL1RVUVNGZGZaM0J4KzQrbUdMMlE3cXQxRlJWRHRj?=
 =?utf-8?B?YmkyNldrRGhKOC9waWI5NUw4L3hLeEc4NXRQZlFSQk92dE9tZU5ocXFYZ21V?=
 =?utf-8?B?MzRqYm92WjMzNzFoSXQzVDJ2dFBLVFkxWU1vN2E5S3VZWGNLVFdldXlkajE3?=
 =?utf-8?B?WlpQSGZkVzVTYUNKL1pDVWNiemxaRk1jV0dYa0dQUmNzZEMvTE94Tk41TXAy?=
 =?utf-8?B?U3ZrSWRvUGhveWRvQmlFeEkrdndlR3ZxUmpBZ0FDdmRHdzJZRWJqY2VGZ0hK?=
 =?utf-8?B?dEtEWWxGSm4zazZEdm5hSUs4VkR1N2gzY0RKL2RyTWFacEJUOVJ3bFJ6L0hQ?=
 =?utf-8?B?MVdTZlZKRXQ2QzkyUll2Y3JWSkNFbmkzZmlCVFQ0aFF0bGs3bE1MNGQ1N1NN?=
 =?utf-8?B?NFlsM0t4K1NOeElsWStPeGxNNTJZT3IwNkRMbVROeW4vUXJxYUVHRG9hMmpr?=
 =?utf-8?B?MUtkbGJoWnRmZUNrditXN2d3M3JGR2pHWXAzaFpBd2hnSGlWaDZDckxKNk8v?=
 =?utf-8?B?a3c1Yy91K0xuK0wrM2g0Yzg5WG1KOW9wMXg5WTl0dFF5dUh0QWo4MjFkcnZZ?=
 =?utf-8?B?UVNzYWltYWlxQlFsTUdwYUhJMGd5a1pTbnlUUkRwZkRHTWovSzR0YTBvUlVa?=
 =?utf-8?B?aWxwUlYrV3Z1UjQ2UC9jOUNGa2daOG5OaW5iMGhVZWZ6MmxLNTJtK3dQK0xH?=
 =?utf-8?B?VkRoZCtHMVp5SXVQWDgyVFY0KzM4em95YmhpSWtZeGVqQmZwWXpQa0RIR0ZH?=
 =?utf-8?B?YlVyT1h4azZjSlE4YjJpc0k4blJ0S1RncDFqWlZmRGsrS1BFdGxSVmM5UFNK?=
 =?utf-8?B?MEV3cjh0VWdacy9yblZUUUVmdnEwZ3MxaGlVT0hVd3pFRVE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZzFTeWd1SkRVQ2p2Wld1WTFXaUNjaitzekU3T1hBazlJVHNCUDUrKzRoNDk4?=
 =?utf-8?B?STJiRS84bDNlZWl0bFpBQlcrdy9KZDJSN085bnlqN1JxWDRwNFA5WXQvVjdm?=
 =?utf-8?B?WlpOYXlrS3g1VitYUnZpWXF2V3RqNVZ6WWh0VE5tWXVIazA4YURIc0tFSklC?=
 =?utf-8?B?R1g5dDdDZ0o5bmRaQ0tSbENTbnI2enUvT1VOdTg5M1RuWXhWelNzS1dKQWIw?=
 =?utf-8?B?bkcraHB0WVU2OFVCUEZrcU9YT3pac05rQjlzYUw5KzdoL0RQNXJYTksybjlk?=
 =?utf-8?B?bG5uZ0tUZFF2NG1kUzltRW5mTVlYdEhGQ3BsdTBleUwyWGVjVG5uRTJ0L0pm?=
 =?utf-8?B?emdPMWxzTlhaM3JwZWJ3ODQ4bUxvRllUSzd5OERTYWsydDRLMnBFZE45a1M5?=
 =?utf-8?B?TVF6dVpUMVFxZEJwSjVJaWxHek90RS9JY2FwbjBmTHh0SFd3bjRqT0phZmZz?=
 =?utf-8?B?Y0VmWmRUZmNnTGo0ZFFzUWZiU0xuMUdzME04Nm9mVWluanprNWZtZ1A4c2gr?=
 =?utf-8?B?akhINDJ2VGF0bnBpNkJEZFFxb3hEcFRVd05sUExIb1lxVGFRTUphV3NqNGJt?=
 =?utf-8?B?cjdtNzllcmN6SWdFRlp5RkpsRTdDUlpxVGpTaU0zUm1GcWNiOVBjZThlbjFQ?=
 =?utf-8?B?YVdWNDF6UGQvZnhVNzdqVk9GeHp0RktTZ2dNMFpRVkVQb1Yya2UxWEFpbGFm?=
 =?utf-8?B?TW1EOXMvT0lQR3BQRmlCYTd5NUNxOG1LNVYwSEJZVkhtTU15U2Zkb1ZLU29H?=
 =?utf-8?B?SWNpZm9tQkVQeTRwTlovUXJGU1hxOHF0ME13a0VUNmVLd2xRZW91S1pMRVJk?=
 =?utf-8?B?SEhDTlZKdXcwa1BNckcvOVhDWFpUSWFkR2R4T1cyakFUM1lPdHNNZFZzN0xT?=
 =?utf-8?B?OVI0WWxhd1RpczVQYzNKeFlCbjQzV3VXOG9HWUhRUmtMNlNaRUozeUxrWlBr?=
 =?utf-8?B?eU1vK0FFMlFRRllTT1JjRmd2TEVsL0JPRVUwaHpvUzRmMXQ4YVdoNk10dnNn?=
 =?utf-8?B?eSs4MFJsU2hpWVczM2d0T2U5Y3VJYXk3bjVSNC8zZHVpSklGVW9CUk5sSm9y?=
 =?utf-8?B?WmVnZ3RUbGRody9WL3lqMG5VeHU3ang3eEN5eXE2d3drSnNsUXZwc2x0ZThr?=
 =?utf-8?B?R3JDaTQ4alNJRmttQXRUcTZXay9YY2k5dFVkWkFGTjdBWEFVUERWbHZtWVdR?=
 =?utf-8?B?TWdqaFh2TFNzQXhZT2FxU0F0U2I0ZmF6eUorUm95bmRxNnU5UEdKRFUwRllT?=
 =?utf-8?B?RTRHVHhZNFNqQmMzdnFyTXBqVkVuRTg5dGgzUTFzeVNuLzZibmdJaWp4L1lp?=
 =?utf-8?B?Tkk2N21kcUlWSUNUV01Bcks2VVZTK2FvVlRJcmtlYzQ5MmI0ZmlKdXRoOTda?=
 =?utf-8?B?SHhHMTF4V1BUU0lMMG8rV3lrSTNzc2ZQRjBCNzkvejBmdlQvdC9qdHVSNTR3?=
 =?utf-8?B?SUJZQ2JESElrL216dktaS212TTVCM081Q3YwVS9GSEIwaVVqdmN0UzFNMzFl?=
 =?utf-8?B?TFZNdFBMTmozK0trT2tpdW5yQmVEeGdqbkl0UXZlU3lJN3lJczFZcDZ5M1ZW?=
 =?utf-8?B?KytUU3pkOWpXd1haYXU2NWVNUExKK1d1RE8wVmVCb1k1L04zaHFqcU5XcTF1?=
 =?utf-8?B?Vloyd2V3NGMvSXA1b09pTGs4cFpTT3UvaTk5TzI0TGdEY0JEaDBsOHRqNVFk?=
 =?utf-8?B?a1owMHJiZ0YxeVZrYzF3V1ZVTHdCRm81L2FJbE1jbDU4WlhURnlITE8wUU0y?=
 =?utf-8?B?S0NYMFpnS0k5VDN1ZWxsM3hvTFF6R0QxS1BqVkhKVG83ZG0vRklQcU9YRGRY?=
 =?utf-8?B?aC9hQWcvQ2M1c0gzSUlkdCtpUzUwNTgrUjhnUnoyTDJCeFdlTllJcDBpWkFh?=
 =?utf-8?B?SDk4MTBLUnVBUWhONW55RGx6SmpibHB0TU1PSzcveG12UEVRVXlYMXJGSXhm?=
 =?utf-8?B?MGE4VWZqeGNkckNjUW9HL3dOSGZGQ2Z3TFUxWC94YitzaTZGV3hod0dHTmNj?=
 =?utf-8?B?cnNXQVVxYWtweGhFY1hyd0hBeFIzREVKalNMZlgxWFpmbWpmaDJwRk05b0N1?=
 =?utf-8?B?L1kzazU2TWpBT0tudU5HTnExOCtuY2QrUXpiOGdIWEliOFVSa01rVUJBei9E?=
 =?utf-8?Q?nxndmpvp0PmB0O2VgGsKrN6ah?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68ca492f-4f82-4d0e-2426-08dcad30255a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2024 05:02:27.5850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RlJ7Fwm/4KKTrZ+uAcoTHAMzuoYwCFi+ob0355IKBd4sWcAyrr7F+KYhGJNToQJ5jjDjmF8hC3nwgl8nH0dY6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5308
X-OriginatorOrg: intel.com

PiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT4NCj4gU2VudDogVGh1
cnNkYXksIEp1bHkgMjUsIDIwMjQgMTA6MDQgUE0NCj4gDQo+ID4gT3Blbg0KPiA+ID09PT0NCj4g
PiBJbXBsZW1lbnRpbmcgYSBSYW1EaXNjYXJkTWFuYWdlciB0byBub3RpZnkgVkZJTyBvZiBwYWdl
IGNvbnZlcnNpb25zDQo+ID4gY2F1c2VzIGNoYW5nZXMgaW4gc2VtYW50aWNzOiBwcml2YXRlIG1l
bW9yeSBpcyB0cmVhdGVkIGFzIGRpc2NhcmRlZCAob3INCj4gPiBob3QtcmVtb3ZlZCkgbWVtb3J5
LiBUaGlzIGlzbid0IGFsaWduZWQgd2l0aCB0aGUgZXhwZWN0YXRpb24gb2YgY3VycmVudA0KPiA+
IFJhbURpc2NhcmRNYW5hZ2VyIHVzZXJzIChlLmcuIFZGSU8gb3IgbGl2ZSBtaWdyYXRpb24pIHdo
byByZWFsbHkNCj4gPiBleHBlY3QgdGhhdCBkaXNjYXJkZWQgbWVtb3J5IGlzIGhvdC1yZW1vdmVk
IGFuZCB0aHVzIGNhbiBiZSBza2lwcGVkDQo+IHdoZW4NCj4gPiB0aGUgdXNlcnMgYXJlIHByb2Nl
c3NpbmcgZ3Vlc3QgbWVtb3J5LiBUcmVhdGluZyBwcml2YXRlIG1lbW9yeSBhcw0KPiA+IGRpc2Nh
cmRlZCB3b24ndCB3b3JrIGluIGZ1dHVyZSBpZiBWRklPIG9yIGxpdmUgbWlncmF0aW9uIG5lZWRz
IHRvIGhhbmRsZQ0KPiA+IHByaXZhdGUgbWVtb3J5LiBlLmcuIFZGSU8gbWF5IG5lZWQgdG8gbWFw
IHByaXZhdGUgbWVtb3J5IHRvIHN1cHBvcnQNCj4gPiBUcnVzdGVkIElPIGFuZCBsaXZlIG1pZ3Jh
dGlvbiBmb3IgY29uZmlkZW50aWFsIFZNcyBuZWVkIHRvIG1pZ3JhdGUNCj4gPiBwcml2YXRlIG1l
bW9yeS4NCj4gDQo+ICJWRklPIG1heSBuZWVkIHRvIG1hcCBwcml2YXRlIG1lbW9yeSB0byBzdXBw
b3J0IFRydXN0ZWQgSU8iDQo+IA0KPiBJJ3ZlIGJlZW4gdG9sZCB0aGF0IHRoZSB3YXkgd2UgaGFu
ZGxlIHNoYXJlZCBtZW1vcnkgd29uJ3QgYmUgdGhlIHdheQ0KPiB0aGlzIGlzIGdvaW5nIHRvIHdv
cmsgd2l0aCBndWVzdF9tZW1mZC4gS1ZNIHdpbGwgY29vcmRpbmF0ZSBkaXJlY3RseQ0KPiB3aXRo
IFZGSU8gb3IgJHdoYXRldmVyIGFuZCB1cGRhdGUgdGhlIElPTU1VIHRhYmxlcyBpdHNlbGYgcmln
aHQgaW4gdGhlDQo+IGtlcm5lbDsgdGhlIHBhZ2VzIGFyZSBwaW5uZWQvb3duZWQgYnkgZ3Vlc3Rf
bWVtZmQsIHNvIHRoYXQgd2lsbCBqdXN0DQo+IHdvcmsuIFNvIEkgZG9uJ3QgY29uc2lkZXIgdGhh
dCBjdXJyZW50bHkgYSBjb25jZXJuLiBndWVzdF9tZW1mZCBwcml2YXRlDQo+IG1lbW9yeSBpcyBu
b3QgbWFwcGVkIGludG8gdXNlciBwYWdlIHRhYmxlcyBhbmQgYXMgaXQgY3VycmVudGx5IHNlZW1z
IGl0DQo+IG5ldmVyIHdpbGwgYmUuDQoNCk9yIGNvdWxkIGV4dGVuZCBNQVBfRE1BIHRvIGFjY2Vw
dCBndWVzdF9tZW1mZCtvZmZzZXQgaW4gcGxhY2Ugb2YNCid2YWRkcicgYW5kIGhhdmUgVkZJTy9J
T01NVUZEIGNhbGwgZ3Vlc3RfbWVtZmQgaGVscGVycyB0byByZXRyaWV2ZQ0KdGhlIHBpbm5lZCBw
Zm4uDQoNCklNSE8gaXQncyBtb3JlIHRoZSBUSU8gYXJjaCBkZWNpZGluZyB3aGV0aGVyIFZGSU8v
SU9NTVVGRCBuZWVkcw0KdG8gbWFuYWdlIHRoZSBtYXBwaW5nIG9mIHRoZSBwcml2YXRlIG1lbW9y
eSBpbnN0ZWFkIG9mIHRoZSB1c2Ugb2YNCmd1ZXN0X21lbWZkLg0KDQplLmcuIFNFVi1USU8sIGlp
dWMsIGludHJvZHVjZXMgYSBuZXctbGF5ZXIgcGFnZSBvd25lcnNoaXAgdHJhY2tlciAoUk1QKQ0K
dG8gY2hlY2sgdGhlIEhQQSBhZnRlciB0aGUgSU9NTVUgd2Fsa3MgdGhlIGV4aXN0aW5nIEkvTyBw
YWdlIHRhYmxlcy4gDQpTbyByZWFzb25hYmx5IFZGSU8vSU9NTVVGRCBjb3VsZCBjb250aW51ZSB0
byBtYW5hZ2UgdGhvc2UgSS9PDQpwYWdlIHRhYmxlcyBpbmNsdWRpbmcgYm90aCBwcml2YXRlIGFu
ZCBzaGFyZWQgbWVtb3J5LCB3aXRoIGEgaGludCB0bw0Ka25vdyB3aGVyZSB0byBmaW5kIHRoZSBw
Zm4gKGhvc3QgcGFnZSB0YWJsZSBvciBndWVzdF9tZW1mZCkuDQoNCkJ1dCBURFggQ29ubmVjdCBp
bnRyb2R1Y2VzIGEgbmV3IEkvTyBwYWdlIHRhYmxlIGZvcm1hdCAoc2FtZSBhcyBzZWN1cmUNCkVQ
VCkgZm9yIG1hcHBpbmcgdGhlIHByaXZhdGUgbWVtb3J5IGFuZCBmdXJ0aGVyIHJlcXVpcmVzIHNo
YXJpbmcgdGhlDQpzZWN1cmUtRVBUIGJldHdlZW4gQ1BVL0lPTU1VIGZvciBwcml2YXRlLiBUaGVu
IGl0IGFwcGVhcnMgdG8gYmUNCmEgZGlmZmVyZW50IHN0b3J5Lg0K

