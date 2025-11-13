Return-Path: <kvm+bounces-63036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4184C5990C
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 19:49:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DA0B3AA5D8
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 18:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED1A2314D03;
	Thu, 13 Nov 2025 18:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WXnexT1I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5B02147F9;
	Thu, 13 Nov 2025 18:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763059766; cv=fail; b=q0CF2HOzTUNE7YzLuCvY+dtrvUMgOM+u7d/aLafW1vsoLhe1qCBVDGHz7VE2WeFXxdfcw46uY5IOsiHQOkNgfcDVX+LQ33LHvexRqcOYno2FUQqHJiiVxhPYS99+GTMbx5ub0Wyvda4w/Z9mEyBZoRi7QdNCN7kTotzEkvsDXoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763059766; c=relaxed/simple;
	bh=pBd59Lb1E3bBtHN0dNCyQP0Un1uP2NQekjevSP85fSA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pQWXW+CcKj0GX9aNu9JZZkY4FI1zSiCvlyPAFQn5l5fL+ilQ1Lzfknw8kC85dMP22Rw16aMYPORWPv00pspwgx3KAHJQq+vInRfY/xflHiUINh+ooopmbhAVaITt1vwk8gKeOgyDFsOrEsliDpMa2kYufjT1FQ3gjwRoMh246iI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WXnexT1I; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763059765; x=1794595765;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pBd59Lb1E3bBtHN0dNCyQP0Un1uP2NQekjevSP85fSA=;
  b=WXnexT1I/x0RKpbmt/5dS0sxI9/5cwH1K/WAJhBIEgFdAQyhP9lq5Zfa
   exL/hjjz7MP2qaRLZbgFG0Kv4wHQ/I8aRo2Avh78MimYaEvcWpyxoNAu0
   8ceTFoSd4Pp1ISzxDFcS2So4bYiA/Fg57qUSG8P0C09p076WoxJWMrf3g
   rColkn5o9z6rxPn68sUz7nm+d/NdoeqjNdM2mcxuQ1+60L8HJBzClnCBr
   xkkcfHHEZqkFQNbC3d5rswuTO7AniXi+YZrSu0O7nbqWYRjHFQMk5jxFi
   DVW7/BsfiOunWMiwd2uvLKIaoFMpR1+JDcnVre7djE2hIV4s1KzOYxHny
   Q==;
X-CSE-ConnectionGUID: ZNKSM9b2TnWupZVvbsxngA==
X-CSE-MsgGUID: Z2n7L5XeRbmeQvl2UapRyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="87795444"
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="87795444"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 10:49:25 -0800
X-CSE-ConnectionGUID: Lz9TjEAxSaaBk6fm6el8gA==
X-CSE-MsgGUID: qHIAT3WeT1C7ezN42JwiIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="220211635"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 10:49:24 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 10:49:23 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 10:49:23 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.37) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 10:49:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YmPUURt5kLgYJz0GmhdT8hKSY/nr6UUpKMjSAg4ElUZZ4eUKedHo/HJSFW02SCNCC4wjA0lPWwi8CnOF3D1z3IOqg3ScR+ldzD/saYDteMPn0Z5R4dzUpQobIze9MCxJczQrk1lpqjoAJts1bQgPIz30Ze0+UQPnrA0XtvHlR7LiYrCNYaMR3QLlWBniq/z4uJDFau2lE7z+zSVFpXAH6AvhF73+3+JVED4Rj0ef4nqkDx0F8bQNtr7vlbKtWfWqJWkLOAQnO2l5+X4XKtEqc7FORmDULa0w8E689B9xNY3/xm8NKHstLoVVRucjj6A5ZtHveBaY4PXwiJJGuepW2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBd59Lb1E3bBtHN0dNCyQP0Un1uP2NQekjevSP85fSA=;
 b=FPXs8a3ZPLL5PlmDePzwuqqwh/LyHxHskKUKF4c3wDE1s5LPU3T4pTkY7Xv1gv44exLWskTlgF5wGos076Gi52txRMpBled0ursHHEPOOp0fO7Tb2+t1jWBhZzafyEIhI+OYCNaQgcu8oJI689X5cI5Ibk9zzkZUQcckFcbWH2eYQu2DFT1owPWET9zcYeH3GzjVr/ocqpgCjFMMqhmIOUR4lIRdq6zpsPvK+rRv1CvnXRnI7ihq4VDsg1H5eSDrXgZw+Wb3GQ9Yf/oKxJimjNIfkrWIoulyVuK1va0avkb6lIvOwJu2iICMWRHco8HWcLtNtjdPxkVdE6K3cYvrEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB6846.namprd11.prod.outlook.com (2603:10b6:806:2b0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 18:49:16 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 18:49:15 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"thorsten.blum@linux.dev" <thorsten.blum@linux.dev>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kas@kernel.org" <kas@kernel.org>
Subject: Re: [PATCH RESEND] KVM: TDX: Use struct_size and simplify
 tdx_get_capabilities
Thread-Topic: [PATCH RESEND] KVM: TDX: Use struct_size and simplify
 tdx_get_capabilities
Thread-Index: AQHcU/gkAfgZ+wGWiES13FGnHy0VB7TvdbAAgAAHMoCAAEe0gIABCL4AgAAnJQA=
Date: Thu, 13 Nov 2025 18:49:15 +0000
Message-ID: <4161146b195efee57393b65f8e9022d4bc7e443e.camel@intel.com>
References: <20251112171630.3375-1-thorsten.blum@linux.dev>
	 <4a2a74e01bfd31bc4bd7a672452c2d3d513c33db.camel@intel.com>
	 <aRTtGQlywvaPmb8v@google.com>
	 <0d9e4840da85ae419b5f583c9dacee1588a509ba.camel@intel.com>
	 <aRYHVHOex4zkyt5z@google.com>
In-Reply-To: <aRYHVHOex4zkyt5z@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB6846:EE_
x-ms-office365-filtering-correlation-id: 8411618b-f9a8-4223-6082-08de22e55825
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cUUxcWozMlM3SkF6R1NhYkJjczVLd2wrV0ViSzdUV003ZnUzS2V6dHIzcmFZ?=
 =?utf-8?B?blVzazI2OWhldWt0SGcyRkN2QTZ3T2k4VC9ZckRBa1cyYlQxQWhyQnQ3WWdM?=
 =?utf-8?B?S241NzYrTEU1SWVvZTRQWnhPU1ZLdGxmdkRXckQrRFpJc0RmdXQyWkpGSmx6?=
 =?utf-8?B?ajJIcFJ1MWp0VmYzTlNkN0NGNk5MRXk2NEJPeGV3TlhyV2dXMnpHN0s4TURz?=
 =?utf-8?B?ay82Uk5mTnd6cEhhNHNZL0NzQzA2YkVGY1VVbStGbUxoUk9NQWNmM045V3dK?=
 =?utf-8?B?R1V0NnVvREVkR08yQWNvbFdrNUFOdXpZMlVZMGNvTmxSMFNvMzFwUHZhbVFW?=
 =?utf-8?B?TGpYMkJ0STJ3aXdBWVVmZDhwbWkxTUY3dmo3bkh2UHE4d1M5c0xxWHJoTUdr?=
 =?utf-8?B?SElPc29wL1g2Rno4SWFGUkxjUUZSWnNoSGtIZjJMUkwwMGYvY3NJTjFEUHBQ?=
 =?utf-8?B?UU4vcDhTejBtbm5JYnVLNUM1MEwvTUlIclk1NzdoMmtiTHg5b2tPdzFQSzNu?=
 =?utf-8?B?Nkszc2VLVEZyT1NPbEI5ck91bS9SL2I5ZlA5V3dWbVRuTHExbHYwK3ZwMk8v?=
 =?utf-8?B?K0RjRjRSbm45ejBiUW01bEROMGgxbTRTZjZ4K3l0MCtyaitJd2Y4Z3AxZytJ?=
 =?utf-8?B?NGcvbGJsZzZtOWVkYlZZT2RGMmJtVmhhdkdJNzYyTUlVTEwwYk1NYXhBM0NE?=
 =?utf-8?B?OFA0VGd0WXkyMXVsTnlBL09zTi9aM0UxNm43UTgvbUNlVWZsREtTSmtqNHZM?=
 =?utf-8?B?WkNOR2FDTnhGSTYwUGwrdGNQY2hvQVJuMVA5SG1OOGxYTGx6cGtSZExvLzRS?=
 =?utf-8?B?d3dMMUN4MDc5czlwMVZCTzRzOWtSMlpHL20zUW15eWVjb09yS1VYMWUxVGxl?=
 =?utf-8?B?S3dGWGVndFFpNHpzU3l4aCt2NG11WXVCTzVEUXRYckpvb3JDbWo2aHZZeTRP?=
 =?utf-8?B?dDhic2RlWEkzemcyWnRyZnM5M0JuNXpWRzkyM1J2TC8yNEdjZXNqMHYwU3Ju?=
 =?utf-8?B?VlNvSXZMWmhJVDhwVFVHL1pqd3BDTWV0MmI3Qm5WQjlMVEsyeUJmUkl5VFo5?=
 =?utf-8?B?d0pwVlRvQzV2SmZiZHBxRlpTZE9keHpyTjdWUEZBR3ZMc20rWDVFUUVTZjFC?=
 =?utf-8?B?MXBka1J3UW5wVzRVWlgzdDdnZVBBMkR4RWNuc0RTUWYrYzVXNkNDNm9YeTdS?=
 =?utf-8?B?dmZHQkx0WkM2Rlp3bXZKNjRYelo2L2ZmN1NvMzMxM05ETHNSUlp2cG5aUXJH?=
 =?utf-8?B?d2RlWWh2dTh2ZXVRcmFVYnlBMkpqcXIwUEx4TkhQb3BhZ25YMVZ4NGh2UE12?=
 =?utf-8?B?MzNDSk1ObVlEUlVrMEZ0bUNJMi9iZ3NzaXlEbTN3cmlCaFcrVjNleDJrYzBj?=
 =?utf-8?B?cUJtUWoveFo4eXZRRXErYTdXd1AvNzk5eml2UlRoSHZwd05tVWpLNWhwSzlC?=
 =?utf-8?B?a2s2eExpbWpRQUxsK1BDU2xwQ2NFUzhSRm9jdkJ4a3BwRTRPZWdZR0FVVk1z?=
 =?utf-8?B?T0xCekJlRTV4YTNTTERUMG9kSkpVcHc2ZDJFblFQY2xYOXRrMkRMRG9DZGN4?=
 =?utf-8?B?SjNCUkYyT3RpRkVMWTYzeVhRU2hxdktCYjNQMmJxUkZFSzJsb3pwNURwRVlr?=
 =?utf-8?B?ZS9JaWw1NXFheVRKck1rd0wzaHNMOG9NNjZrR0xqc2dJdjdHMUhBOGRtRlVU?=
 =?utf-8?B?Q0Z6SXlrK2g3Ri8wMklzbkNTYjhvVXVUYlMrVEhPMlNRcVVnL1k3VklNMTNO?=
 =?utf-8?B?bWREM0Y5Z2dKejkvQVQ4aiswekFyRVlaQ3pkSTZJV0xlb2EveENkdUVjVXRo?=
 =?utf-8?B?WjZRcUVMYVUwNllyYVNSQXplb0dJTFNnTnVxYVBMa2VzYStnSE9UUGxnMFRY?=
 =?utf-8?B?MTRxNkJzaFVCTlZ4UnNreGVEdTNhYkw0akNGMHFlejdxbTVjTXV3b1ByOVNM?=
 =?utf-8?B?VThlalBwREkxUmFBaVpDMkdtY0RCY2ErQXVXd1p6dXdzSWluZThCb1NlOVlp?=
 =?utf-8?B?MW14dDkwd25CMWpIdTA1MzkrZ25sbFE4dEVMemFtYXJUWXI2UGNGT25rWisv?=
 =?utf-8?Q?66b5bf?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTB1QkJETlFaTkNmeDVrUzJtcVlyeTd3T1c2YUhLSDdsTHZPbUN0TFBWaXVs?=
 =?utf-8?B?b3lMbnpHRmxnbkRmS2tDdjBZV1Z2WWRkOENPem9oTVh2K0s3SS9nMHJtektM?=
 =?utf-8?B?ZEJVaDJtUEhvZ2MvT1pjb0VMK2UwcnRrNzR0MDNGeThYRFgvZEhuOExwZGhB?=
 =?utf-8?B?M0s0VVRvUmx5dzFBUy8yVjl5RWNuUnhXc2hKSkRtMGdab0tGbmRJMVhnY2hM?=
 =?utf-8?B?Ri9mbmwzNU1XN3JUeVhmc0RURWt6OWlEdFJZYkVBZEFwQk5TR1o2Z3lCc013?=
 =?utf-8?B?cW9nQU5idzZhV2d6T0hnY2FERWVqd3ZiNHNqRHBVYmxHTW42OGdydWhRaUdY?=
 =?utf-8?B?Q3g2cSs0d0ZHY1cxazZMMWJiV2ErNEhKNkUvdWk2VWZ0SUpQWmpQSG41UmYw?=
 =?utf-8?B?SitNNEdjdkxqeFVaZFVmQURTRzJJMkltOEJweDJSd0pDeXB4T0JtRFRTTGN5?=
 =?utf-8?B?QkU5b3lOSFEyeDN0cXhGa2I3QjhPYXJkWFExTjM5WjVoblozMDJ3OTJyQ0JQ?=
 =?utf-8?B?R3p3NlVtVVVsQ3ZLTXpXdXcvNzVlMEgrNUJEYXNobmdHcnlscGoyeWh5VEg3?=
 =?utf-8?B?Tklpdi9MMjZpOE9Qd1VvWm9kcUlLOEp6cHVoeHVMVG1YVUE3OXBoY2o3Ynp2?=
 =?utf-8?B?aG9JcHV2MC9nRGUxSDBtNDBmRXBKMnBtWnFjSWYrMU9YWVRybGV4TVVlaXBP?=
 =?utf-8?B?VjBPU3h1R252S1FzcFNVWkV4dnFScFUwNHNaMk8zc2d3NkEremZRWkpWbUJx?=
 =?utf-8?B?aTBwa2MybXZ0ZTRiaUNINWdNcmIxR0JVdERVaGRlWmpXWFh1ZkE4UXhiZlpm?=
 =?utf-8?B?c2p1Q3lVa3hEMlN5VWxNaWhpUldCK1JrQlBkSEEwY0FHdVc0VjRLTWpNMFVB?=
 =?utf-8?B?V3hEVXFDM3hMNjBHNjNQT0U5NGlldHNaTy9YaXFpb3BlcG1pRzJLMjl1dXBE?=
 =?utf-8?B?R1RIMFRkdVBZUmMyUDE4TnhHcUkwaGoxd2E5VDJOcnFFVHhsNll6c0U0NUk4?=
 =?utf-8?B?dmg1UzhRSjBTTzl2UDNzUCt4RkdFNXFldGtWaGVjVENkbmFFbFhtMS9lUi90?=
 =?utf-8?B?Z2FWV1c0NmpITjRmZkxwaktMZjN1UTg5ZitNdTM1am1obWNwTnR4aWd5SFNP?=
 =?utf-8?B?ZjFxNjV4NjRpSCtXL2ZKcnpEUmE0U1lPRVZMK3FVcGVvaWZFYlZDYXBYVU1W?=
 =?utf-8?B?TjdhWDVRSTBDeUppMXgxV1N4R0k2Zmg5T1JEYlpST0JGVng3eFJoOEhybUJB?=
 =?utf-8?B?UWVSWEw2dE51S0NGY25SV1pkWFNXdTM2blhMWDh4Zkp6Z1BVTFQwbUxNb2ZM?=
 =?utf-8?B?NDBpT2oxYi9taWpSRGU1WUR0NWtodmNrMVE3eHlvcWRiZXJ2OTJmVlEzNUhX?=
 =?utf-8?B?b1gwMHEyR3pRSXM0d0RTRWtoQVd1eGdBMjYvSkZNWFRiRk9VNDhnejBrMis4?=
 =?utf-8?B?WEh3RnMrbFdSdlpUamFPbGR6RUIxRklETUIvTW82ZHlabE45SWI2UnFuZGg3?=
 =?utf-8?B?NlZtV1k2UXNMeHEydmRvTlh6WGd2OFZwSjBoRFBoNEViMnF1THltMEdWeC9n?=
 =?utf-8?B?L0d1YjQ1cWQ1eG9Sa2RJbC8wNEpoYWdhQXZlbTVpa0R5YlNuRHhQL1dTbmhH?=
 =?utf-8?B?R2VNbThveEFMK0d1SWY2NHJPbXluS3pHUHZjUkZ2WEdRUG5hYU5WQ3R3N3ZK?=
 =?utf-8?B?bmZGM2p2V05oSGcyS3R2VDlKMGUvakE1djZRQThHZ0VZa0xEbzNPM0tlYy92?=
 =?utf-8?B?YVFtbFR0MlJlUE5UWjhYV2hmNTkxZHlDWkp0OSt4b3NYRXdRdlpTdklkMlk4?=
 =?utf-8?B?ZC9lSjFPaDg2cnFXUEJpaE15MlZoandFY0xXRzFvcGhUOVlZMFJiSXpucnFY?=
 =?utf-8?B?RkQzdWhVQU1jU0pZZExuM3dyM3ZrcHhsRDhXNHBPYjdocUwvSXkzQ0xDaDhr?=
 =?utf-8?B?bW11VkVSamM5aTFnbWc0NUd5TXNnRzFtelhuSXM2SWlnRDhZRXNUKzZMaEVw?=
 =?utf-8?B?VGkySVdWclpUZVRMNC9BdldVNnNrdU5kdmZ5TUZZSTdMR3V1U1RCWmpVQ1F6?=
 =?utf-8?B?NzArcENCOVJEQ2I3YUxUbTBhUkVDTDdINmVLSU9NQ2F5eldvZjRnNjRYazdl?=
 =?utf-8?B?NzhFajRrbzRVZTBGK3YzUEpqblduVmxmcEx2US9CdXZaVmRINVNrdEQ3amVr?=
 =?utf-8?B?Q3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C583A9307A66AC42AA9687309DC1525D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8411618b-f9a8-4223-6082-08de22e55825
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 18:49:15.4755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6SZ+3EtZAhPGUmkMv98inojW9DwXJ3Q8zYU1Q53nX2DP+N02tP27TjSgRMSJeaUKxqG3dafP4sgefKb/rsxofxhuibW56/mA3w9FfTmZFyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6846
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTExLTEzIGF0IDA4OjI5IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBc3N1bWluZyB5b3UncmUgdHJhY2tpbmcgbGludXgtbmV4dCwgSSB3b3VsZG4ndCBi
b3RoZXIgYWRkaW5nIGt2bS14ODYgYXMga3ZtLXg4Ni9uZXh0DQo+IGlzIGZlZCBpbnRvIGxpbnV4
LW5leHQuwqAgSSBkbyBwdXNoIHRvIHRvcGljIGJyYW5jaGVzLCBlLmcuIGt2bS14ODYvdGR4LCBi
ZWZvcmUNCj4gbWVyZ2luZyB0byBrdm0teDg2L25leHQsIGJ1dCBhdCBiZXN0IHlvdSBtaWdodCAi
Z2FpbiIgYSBkYXkgb3IgdHdvLCBhbmQgdGhlIGVudGlyZQ0KPiByZWFzb24gSSBkbyAiaGFsZiIg
cHVzaGVzIGlzIHNvIHRoYXQgSSBjYW4gcnVuIGV2ZXJ5dGhpbmcgdGhyb3VnaCBteSB0ZXN0aW5n
DQo+IGJlZm9yZSAib2ZmaWNpYWxseSIgcHVibGlzaGluZyBpdCB0byB0aGUgd29ybGQuDQo+IA0K
PiBBbGwgaW4gYWxsLCBleHBsaWNpdGx5IHRyYWNraW5nIGFueXRoaW5nIGt2bS14ODYgd291bGQg
bGlrZWx5IGJlIGEgbmV0IG5lZ2F0aXZlLg0KDQpZZWEsIGxpbnV4LW5leHQgYW5kIExpbnVzIHJl
bGVhc2VzLiBPaywgd2UnbGwgbGVhdmUgaXQuIEkgd2FzIGp1c3QgdGhpbmtpbmcNCmFib3V0IHlv
dXIgbGFjayBvZiBURFggdGVzdGluZyBzZXR1cCwgYW5kIHdvbmRlcmluZyBpZiBpdCBjb3VsZCBo
ZWxwLiBBbGwgZ29vZC4NCg==

