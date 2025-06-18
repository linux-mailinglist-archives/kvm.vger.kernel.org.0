Return-Path: <kvm+bounces-49913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18032ADF92D
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 00:07:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9E554A261F
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 22:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DD7827E1D0;
	Wed, 18 Jun 2025 22:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ok9Jdigl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD51921ADCB;
	Wed, 18 Jun 2025 22:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750284434; cv=fail; b=DQfqrbSfgGSglhhIWGsiIpRzDqrabdzTnfC7hhv4pgeGRXpvhRoF7eJzN7ahydudbSPIzrU4ehP8qEgogi0BbdCol2YQAWPgiBVRRB8MOFjAc9CO1ZxiQqICYHeyk3K+Q5tPIpdK52wzix2paTIIcGeJt421tV5i7bU1NTK121M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750284434; c=relaxed/simple;
	bh=ou5sW08FaBNXHrnl72BXLNAn4JNaqz9exl0oqHKyKJA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AXuKAvlnJQiSTsVEt5ecfus7xlWES25LLCrdI3H6hMCtfXctcNMA3Jom1LKr71bp7LMuErd94oqm3K2XOcAIdEsqbutKab+tgZSUEke2KkXjl3TSFkINB5Py+Nmfvqad7cqBAn6WRnxW4t3ZxKxCCeo/4kDnab3x+V1m80Nskuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ok9Jdigl; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750284433; x=1781820433;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ou5sW08FaBNXHrnl72BXLNAn4JNaqz9exl0oqHKyKJA=;
  b=Ok9Jdigl1g8qychzfjjWa13VhgMV5MJXViwl27FVXSJzl1waz9qX6PV6
   8/VkHi6Zy7v1hP0ypAOscrDoRF9lG50fzwTb1Y45qgYY0+pq4H3qoMrfD
   gSOQm96bz+CdZKyh5hkZxiT88tD0NqEb8jI+HbZydhgun5Y5pPTPxDDuk
   Zl+QSNLenMerV/PYAG6T+VbX0ZjQutiAWAAv2yncarSrs+pZoY853L9S5
   t6p7p5JqYG7uf33o3TS7YJvIwRJrDgQIQ9NnkRPU/Or2LPPvf2L96Y4Ih
   2Ih8Y5VUy2u0AJ9mdf+EbfzzNLJzKkDlA1ngBETgwAPhlEFje/Aw1rrer
   A==;
X-CSE-ConnectionGUID: Xm4ODOlVTsiuUk1TZAFt+g==
X-CSE-MsgGUID: TdOjK0z2TjWABV0zajbUQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52608561"
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="52608561"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:07:12 -0700
X-CSE-ConnectionGUID: xnaIPeE5TO6Dnqrk08Z9gg==
X-CSE-MsgGUID: GejAkK19RVat6rRM7QMylA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="181308505"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:07:12 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:07:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 15:07:11 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.60) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:07:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xYFVt4ht9daKTfWb7ZvLvf4Ou8N0qjEw+F9p/h+Dur2iSRnvxMo33MQbORvLVI1Kn0dWpnRtzNGPAD6ydPQDPr17LnN8jqUetf6WtE5WXoKU2DRTcPXN/155yhwwtGuLWO2xeLCgR0Z8yKe0apH8rmkr682qPTEXNiN1c3lV77cUJ4w8iTXX/RVVillKREfQLHogO8e2HGyCDuzMiDtvLILC1y9wsuMISNpUNLUmGAEmBMmCLlBqIW0dEjz0WOhrHzYv2188x5nCMM/pisk88IKO0xNaiSfbH02bDsVuPxWfdL0EFACcq7rTO+EAhDHiqbfM3zg31TR9bjmUBkRO6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ou5sW08FaBNXHrnl72BXLNAn4JNaqz9exl0oqHKyKJA=;
 b=gIIWAD68tHLzJvLe09q92KbsQsxPoxopVnNq6NjEjnwoxDKDFLFuRSGbHtUZ/uIj+WlJ8x4KhliHYbVl9h1lEogc89a1c4bF1isBDWolHil9iffQ3Hdj/GiPZIEBNjxsKAPky4jV8EWZRGYykMVavXEILol7q2NxsudPurKvttKqFkqapHIY9ReD0/Vz4XGs8RgvkIEdm34HTFop2jkgbzUZTUpH+BHfOr6QElXYlmdeInGSrJFZKvOkdAUGZjUI81ckmBlLUeVcS4uULe5toLuwC5oThzinCOTzCGHh/Y/fhLL/96n4EIpds0tpI4kqwovVaLgl78NXtKoDMRcI2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6969.namprd11.prod.outlook.com (2603:10b6:806:2a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Wed, 18 Jun
 2025 22:07:08 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.018; Wed, 18 Jun 2025
 22:07:08 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
Thread-Topic: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
Thread-Index: AQHb2raQMvS71doOpkSd//tZsUmNFrQFK1QAgANI6wCAAAL4gIABDgSA
Date: Wed, 18 Jun 2025 22:07:07 +0000
Message-ID: <6136a419b8de3b7b3205dfb0cd85327c58c8ce54.camel@intel.com>
References: <20250611095158.19398-1-adrian.hunter@intel.com>
	 <20250611095158.19398-2-adrian.hunter@intel.com>
	 <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
	 <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com>
	 <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
In-Reply-To: <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6969:EE_
x-ms-office365-filtering-correlation-id: 0212497d-e55e-46d4-d715-08ddaeb4778c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NXgvQVlnbG52UjRwWnMxZjRldEtGaS9kaVBUZjZONlNrQTZLNjBTaStWclAr?=
 =?utf-8?B?U0xiOGFJc3M5Vmg4L0s3S245aU9ZZWt3cDJIcnhvT3NLRDBnUDQ5OS9EbGtU?=
 =?utf-8?B?UHNhbXZNNlo1Y25yUmNMVTdFTDlES2ZvNndGU0lsZG5walBYL2RZRWptTWd5?=
 =?utf-8?B?TVVoVnFUTGpqMmNVbjNUYmFLQ243TTJMRHNsaENSWVNhbERwYTcrUnBsQzlD?=
 =?utf-8?B?RTV2Y2N1SXdKN3JDM3lGYmNHeklLdTUyWk9nQVRvSStWb3k2Ujg2dVRiMW1D?=
 =?utf-8?B?UUtjdHdsQ2dHNjRLcDhLc0I1SjhYNmNOTEU0SmZGeEU2WnczQUJnUVVxOEli?=
 =?utf-8?B?U28rZEJsc09yNjBQb2Z1d2R2WmFmTDNQL3RlTUhDKzk5U2I1b1NFTTZZTUJ4?=
 =?utf-8?B?ZVZkQ2dMZjV3TkV5N2JURVcyMHoyZVcrWlJSVkIrSjZ2bmhSV0JheXNXdEJy?=
 =?utf-8?B?RHhLY2ozd1FOZEZpSEFvYjNaWFZtQlphY3J2d0xsc0dsZUJjdlZhOUJSL0RD?=
 =?utf-8?B?VXlyc2RlVUVQQXZRY2g1ZnZEWTVPTmdFS0RIZ1Q2MmI2TXF0eTRYZThZYndn?=
 =?utf-8?B?ZXBTWDJOUytTVGUxdFVYT2htR2xTT3RWNWxjNnhZa01POFk2NWt6djJ1bXJG?=
 =?utf-8?B?dmF1OUNKdXdndzBvQmN2dG5BUk9ER1NyVEpreHBnbnk0QS9CZ29sQmI0TXd4?=
 =?utf-8?B?ZzJRWlFmckp6MENuUlVwOFZqYXVLNWI1V1pXTmhMRGFwVXhiQVZrbVpBS2JO?=
 =?utf-8?B?aktEbFdLZFo1dm1TRlVxMGxoZUljTms1TnFITk1HeThMTFNpMWFhajlXYnl3?=
 =?utf-8?B?QWJBOXZoL1ZVOUJRZTBWTlJJekFpNFdreHo1cFhzSnRqaTV4L1Y0MVQ1RjlK?=
 =?utf-8?B?WmtsYUsyQ0cydHY1dll4QVNvcU40UHdTSnhXTjJTdU5hK29tQkhjamtMTVJE?=
 =?utf-8?B?RjhSSkltcGQrMGIyYS81MGpSNDRCL1NNUDZWcnhab2NwYUpWaFYwTTFJekdw?=
 =?utf-8?B?bzUzcUFtMGZMQTQvQ2FCc1NsWFI5RVlKRGoxRkxTM2ZUUUdlTitJS0pXaG11?=
 =?utf-8?B?bDJKVFF2Rk1lM09JT3RTbXQzeExjK0RwZ2tjUDB4Y2pQQ1M2K0hWNnA5aTg2?=
 =?utf-8?B?d1A1R1RMNUtPamtlU0J2RDJpQ0tpMnlDR0tQempUMTRLMWNJbkswTzFpUGdo?=
 =?utf-8?B?MmdlYTM0UEE4ZCtxSXdiRXkraDdMZUNjR1lHZVMvRVdmd2NWWHpoS2ZXTjls?=
 =?utf-8?B?T2VNNFQ0VldiR0F1MlBUck9LKzVpYmszUUpSUVRqTGIrNVVNMlZzT0JqRGV2?=
 =?utf-8?B?cUZYb1Q3N2JWTDUyb3FVMHAwYmNSeUg0K1RhSFdmaEM5SVA3aGZZdUxIV0FE?=
 =?utf-8?B?MnBzQ3M1WkxrdWo1Y1lpZ0JiN0t1akNnRkhzSmhuMjdLemVYNXhKYytHNFJz?=
 =?utf-8?B?U2ZFV0Vtdy9xNnplWFJmWjhiMm83NDRHZXgrWmxPam0xU0ZvZi9Gb2hNb0Q3?=
 =?utf-8?B?TTYzQ3lwRWhOVGtjaVczcnhEbTlzTXUxd0xLcHJtTldnVWNQd1laS2xwSnZu?=
 =?utf-8?B?RXM5OFJGdDhvdUJjWHNTclUzZFdxaGhlL2VmTWxRYzN2RHkyUGN3Wk8yYXUx?=
 =?utf-8?B?RGc2aVc5OXRPNDdhQ3Z1NkdkUWhXZmlMajZrR29uMWk2c0dodzdsd0lRSkRC?=
 =?utf-8?B?c3Y1NDZPR01sbkdXUHdDNllVV21ra1pteFptb0VESk5YOEkyS01ISkRmbUcr?=
 =?utf-8?B?anhqWU93Y0k2SUZsMHBjYk0ydExrYTA4TjZQc1l1WFdtMDlybkNsWlp6eUcw?=
 =?utf-8?B?YVQ2T3c0SVVoM1ViS3Q0NkV3Rmtramt3N1o3NjRGNG1TU2c1MnhjeUFYME1l?=
 =?utf-8?B?dUM3cHZTLzc4MU9jc3VGU3B3YW1yNXpIOVkxbHZzTzFBMnB2U1hqU2NmMDla?=
 =?utf-8?Q?H43ngKcEG5s=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bitKWDNBZ3BYamJaUkgvU0JTTDBYNmZncTNEL0E4aENvZVlkMzl4cmtvTjk2?=
 =?utf-8?B?UVBiaGdRb3pMUXo4VUppbTMzOWRWTkdDZFMweXRPQk16ZDRKc2RkZTNBRTdI?=
 =?utf-8?B?c29XOVRjSW9sSWpsa3NwVWJIT3ZQcXFUVHNzSmh2Vm14OVI5bFVQZFFaUU1X?=
 =?utf-8?B?TUlHN3NrOXpQWlZ0cmpHSXh5c2p6d1pYalhsSmtwdS9HSi96MmJEbnpBQXMy?=
 =?utf-8?B?VDdzSWNVRnBmTGYzWnhPZDY5VHU1VHRlSHhucEY5UnFDek5CRllvUW1kVWRv?=
 =?utf-8?B?QzQwbG8vcmhtdHlBN3kzcVNCU3lBbzNqNlRWT0J0djJJRGI4ODhyZGFKWUsr?=
 =?utf-8?B?WUpGVndCQnJvVzNpQ1N4cnhaNXhVOWZhYXJBQzBYcTNlQ2MvckdWZTJ5N081?=
 =?utf-8?B?QzRyUFNOWUtGbGIxZUxLVjlYT2NuVzFGRWlqNmk4MElHazFPRWhMWDl1NHNu?=
 =?utf-8?B?eWlOczZ3cTczZDI5ZzQ1bS9ldnlMeUxlWU9hRFpXV3lFeW1PUXplVU1hcmFt?=
 =?utf-8?B?eE1QbHdTNFJ5RklYM1V0bGFacjNWaU1kbDBlSVhJL3FnTlIxMEtwNnVDMnZU?=
 =?utf-8?B?eTlsUnlOeGk4UjNoSDVBWDJUaTRIMEFPSWtSOUh4bnRHcFVLZGNobU5UV01E?=
 =?utf-8?B?ZUl4eG5rRlBTQU5qWFMzU0ZEVHBLQTN6cE05SlBrU3owbDFCMlZOL3VYdTkw?=
 =?utf-8?B?TnVQV0YxcCtRVnFvNzQyOHFuUHpkUStkM1VPUXB4dTZiSThhMFFZTzdOMzlF?=
 =?utf-8?B?MFRJcVR4WVhHbU9nakU1ZVZwSWZhNHdmSGNaaGxLY24vVVNOZlRCU0lEaUdr?=
 =?utf-8?B?UWtoZVlEZncrcTdIOTBsQWZtdFZTV2lQMHo5RFpXSEFwVThUK1M3Q3JjMVBo?=
 =?utf-8?B?dVBrRk5IVXpvekhlUFdzd2QwR3BJMTdZRWgrSEpBWWhGZVRLSm1FR3REa3pM?=
 =?utf-8?B?SWJ6bCtiV0VUUElNL3N2MGMvR2FHcGlRaFNXME5OT0hEYWxlWkdUeUNuelIw?=
 =?utf-8?B?NmxsRFNIM0tOdzFhL3IyQjVrVWdoYTVzQkNBVGI4a0ovZUV5bXpuODd1N2t1?=
 =?utf-8?B?Z1llV1BnaFVObjZXV0lKRE9TR0gyYjFKNExxUFpOS2JRRzJZWURSUytmQmJG?=
 =?utf-8?B?M21lUWM1blh0YlNQMUl1UlcxZXk5TmV2Sm0rcmYzYis0Y0drcUVqNmM5NTY5?=
 =?utf-8?B?OXE1S3h5bXBNZndXY3NFREQ1QVJ0cFBvcUh0Rm9xT2pOL2puVkp2SE8yWXA3?=
 =?utf-8?B?TzNvSitBMlZkNjJNRjlQNTRDdEhPenh5b3dZL0RKamIzd2xEYW1pNGdEbURK?=
 =?utf-8?B?blA4MWRDRGsxZVNQZHViME9IQktBT2V6RDBXcVpteDdhaDU4bVdBWG9aQW16?=
 =?utf-8?B?K1dHaVJybFlrU1VnNHNyMmcxdFBoKytPcGRhV1lMelE5ejV6eWRZenRSNkhX?=
 =?utf-8?B?VjhIaGhnNCs0VFNtMURoZFI5dG9uSC9MNlJqSjREc2ZjTjhGRXd2QmhCbkpm?=
 =?utf-8?B?OGxWR0creEpCODFLeUpwQ2Z5RzFDZEV4UlpGNksvRU9lQTIwR3MwTENwdEJJ?=
 =?utf-8?B?bkpiQWEwcnNURlpOMGxmNmhhcWUyTkM4TWF6QjdTbWFsSG5CN0F5Yk9TL3V0?=
 =?utf-8?B?WmZXcGFubXdEeFJBdjJlQk1TTmRSQXFTMHN1WS9CTlZTSkJ5NU1OSktTaTQ3?=
 =?utf-8?B?NVRFTlNWMGtOUmFtOXpkRHU1N29yc1BXaDB3UXVzOGF0MldZbW8wS3VoYi8v?=
 =?utf-8?B?Vjd1bFZ5ZlFmelZuK3Mza2FkbTRiZzk2dVovNzJMYmNtdGJ5Q1ZFaGlaV3A0?=
 =?utf-8?B?Sm43MVhaek5JWjhxUGVXMU9GSmJVZzVYTGpYMnplZENiK0hCcU1OVnYxdXdQ?=
 =?utf-8?B?QndpQ0NRUmhqR1ArTFc1QVh5YU5kYml6dXJkQ3ZwQnljRXZWMURtM0JZektD?=
 =?utf-8?B?NlNvaTRuczFIU1hJbVFoQWdOck5RUDJzN20xaUxJZkFQYnM3T1p2d3k4ZG44?=
 =?utf-8?B?MUhZVWNrZFQzK3pYV1Q1d0tJL1duaDQxUUxEMFhJYVB5TFN6c0t0RWJYZk9F?=
 =?utf-8?B?THRwd0ZDWXVYM0k1YzRRNzVqeTdFMGJseUQxeGE0OG1Hc21UMlhPbEVqK0dB?=
 =?utf-8?B?d3l4SHMwMmZlRFJVMnErMEE1MkRLOHdEYXNhWGVKanFEL3kwSVAvWG0vc0h3?=
 =?utf-8?B?Q2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15935C5F3C969947B42C75AB6F4F4A9B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0212497d-e55e-46d4-d715-08ddaeb4778c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2025 22:07:07.9403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FXig/iabXJDWGqas+sCzeROjiYlgzjxPaz4KjcLMpLbKhQusQlWFJnkZjiOwgJiH8BKAN+Fu/aqeLeSFnE7pcxIy6QbHlSg6/bN8qE/7WUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6969
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA2LTE3IGF0IDIzOjAwIC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiBnbWVtIGxpbmsgc3VwcG9ydFsxXSBhbGxvd3MgYXNzb2NpYXRpbmcgZXhpc3RpbmcgZ3Vl
c3RfbWVtZmRzIHdpdGggbmV3DQo+IFZNIGluc3RhbmNlcy4NCj4gDQo+IEJyZWFrZG93biBvZiB0
aGUgdXNlcnNwYWNlIFZNTSBmbG93Og0KPiAxKSBDcmVhdGUgYSBuZXcgVk0gaW5zdGFuY2UgYmVm
b3JlIGNsb3NpbmcgZ3Vlc3RfbWVtZmQgZmlsZXMuDQo+IDIpIExpbmsgZXhpc3RpbmcgZ3Vlc3Rf
bWVtZmQgZmlsZXMgd2l0aCB0aGUgbmV3IFZNIGluc3RhbmNlLiAtPiBUaGlzDQo+IGNyZWF0ZXMg
bmV3IHNldCBvZiBmaWxlcyBiYWNrZWQgYnkgdGhlIHNhbWUgaW5vZGUgYnV0IGFzc29jaWF0ZWQg
d2l0aA0KPiB0aGUgbmV3IFZNIGluc3RhbmNlLg0KPiAzKSBDbG9zZSB0aGUgb2xkZXIgZ3Vlc3Qg
bWVtZmQgaGFuZGxlcyAtPiByZXN1bHRzIGluIG9sZGVyIFZNIGluc3RhbmNlIGNsZWFudXAuDQo+
IA0KPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9jb3Zlci4xNzQ3MzY4MDkyLmdp
dC5hZnJhbmppQGdvb2dsZS5jb20vI3QNCg0KSXMgaXQgaW50ZW5kZWQgdG8gZXZlbiB3b3JrIGZv
ciBURFggcHJpdmF0ZSBtZW1vcnk/IEl0IHNlZW1zIHRvIGJlIFNFViBmb2N1c2VkLg0KDQpJIHRo
aW5rIHdlIHJlYWxseSBuZWVkIHRvIGNvbWUgdG8gYW4gYWdyZWVtZW50IG9uIGhvdyBtdWNoIHRv
IGRlc2lnbiBjb2RlIGFyb3VuZA0KZnV0dXJlIGlkZWFzIHZzIGEgbW9yZSBpdGVyYXRpdmUgYXBw
cm9hY2guIEkgaGFkIHRob3VnaHQgd2UgaGFkLi4uDQoNCg0K

