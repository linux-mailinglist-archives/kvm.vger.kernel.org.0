Return-Path: <kvm+bounces-19899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EAD8390DF0E
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 00:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D88D11C22A96
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 22:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 374221849D9;
	Tue, 18 Jun 2024 22:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k2s9+lJ3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147E117E8FB;
	Tue, 18 Jun 2024 22:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718749176; cv=fail; b=dpUIUG7QXGsEjfZRTrsjMILj805dxN6acHiEAufhMoEIxkoK2MdustvMG9CPsYV2/sjrtkNy49S1EtWjH+YJWsKzGIwPQEy04e9fJg8ag1Qw1a7Ln6CKo829JEqBYU26PJIQ9lyRRU5znYx5dpcwa5MWAQXpULZkyG9DnEVr+P0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718749176; c=relaxed/simple;
	bh=X0XiCNlLmPBCNi+m66l0r5Y7k3GbtF367xDMu+0H2yM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sDkGO0UUSZane/LYZabSDXXAxIlwyKMArVOkLxUB+oPyDfKmlV84BSWDWMffh9nspLE1Ij5vGfFW6gJ28/mXQt/tLENQnzTtcEK22Qt6UPRYxd4gCp7JfzhQ2Ndkd+Wexv6s1vAfE8PBhlGPY0sA3PQClZ+rMrztethmzwyznEI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k2s9+lJ3; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718749175; x=1750285175;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=X0XiCNlLmPBCNi+m66l0r5Y7k3GbtF367xDMu+0H2yM=;
  b=k2s9+lJ3nFDbEfvcs7+ezncd4vi9epONWfVoTCiEXPCmfN00AAk7UkwN
   QZcS+s3Obibdqp5JvqSzgPkV9M8kiZCDGVzWSE7bN/4KSfsNbiuNUZK4x
   G6MJ7yWtj33JPv6OGr9fYjG7wbhPNVw0nvzjuq1w7C13jSVMCRy4bq1CD
   Pfj20a9UTyZztRjv+Z9u0M0jxZHUzcDbcB+mf/D4Tb9AsGYl2z9PMPM8g
   ZSDGYT8SeQGbtCXYd6BkuFYpzWejA2HoEFyoiQzWev3fyotuh5ZsXzcSl
   HmS7st0Snr+2EimuxlqKQmqpRWhCE8BPGxW8u+kwLQjoLpeeBSDXLO8np
   Q==;
X-CSE-ConnectionGUID: 6OfXFfDcQWSd/UOqptWrfg==
X-CSE-MsgGUID: e6KriXIuTZmgyz4X6A6MiA==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="15494379"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="15494379"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 15:19:34 -0700
X-CSE-ConnectionGUID: 9ZoboJ86RbORE/XvfZa+gg==
X-CSE-MsgGUID: YCOX+q6fQXOgDcy4T3cRKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="46651461"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jun 2024 15:19:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 15:19:33 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 18 Jun 2024 15:19:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Jun 2024 15:19:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8zhazqaS86V9O7gr8SDG9R6cPvirL1wNOex/ObrA/p7iywge3woTa9xk83i+o/HPOPrrotT4HDnaDCoE3svRTYA6lXUihma5MMfBvxoeNWnf32E1QQaDlBTIzBatSOiesgppewAsfywQv/pExst/3m9cyL902shE1O30CmBqJOaY4SC43UUOP3KmgPetsDEuTl1nlMgr7I8Z3UIIXaM20RxB5WPyqVUEoHzyxRyrv12+TvqJcOKlRWSRxa5UtvJzA3NpVLYCJT6SX41bSOVGYnb6/Ua/THIj3nOYZpA2oKDutuhHP0LfdlkW0BMDE14sK46IPS6NjCj3hobREiqVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0XiCNlLmPBCNi+m66l0r5Y7k3GbtF367xDMu+0H2yM=;
 b=RIj7eGoxoxo8JqeqtXV7El6lytAUuCuK3sMqogGhr28JU4LH1X5yHLqW00pjlLSZRIJqroqD2uX+rBCMB1dFpMSHRQlby2iMzmmFKASa+0rZDH9hnAX3f5oyvBnllxRwZ2E5GldpJPTAqioffQ+qqDXBioyuk2TIK2GCGPpq6y/fyoA3JRkjQApLq295Zzu4lixdsgRfVKjiqOxBsxE68F4PGr5F19EHt1dqr0Gn3ljCARLxdmnqCCmvmE9cSvAvOXHzCfkbASoSlI6E2uaNSMmLlcd0RGUnzpVIh7uAosio0MFhFx0tDqZdIJPnyIopbwrZ8srHoZNVrGruuQIRKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB8492.namprd11.prod.outlook.com (2603:10b6:806:3a3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Tue, 18 Jun
 2024 22:19:29 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 22:19:29 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Thread-Topic: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Thread-Index: AQHaaI2/dJkfmwuOl0Kzt5Q4G20a/rGPjNSAgABl+QCAAANegIAAB3kAgAAJ9QCAAO1bAIAFfyEAgBj234CAANvZgIAAtdgAgAcL1wCADwerAIABjg2AgASxLYCAAP0FgIAAfaWA
Date: Tue, 18 Jun 2024 22:19:29 +0000
Message-ID: <fcbc5a898c3434af98656b92a83dbba01d055e51.camel@intel.com>
References: <20240509235522.GA480079@ls.amr.corp.intel.com>
	 <Zj4phpnqYNoNTVeP@google.com>
	 <50e09676-4dfc-473f-8b34-7f7a98ab5228@intel.com>
	 <Zle29YsDN5Hff7Lo@google.com>
	 <f2952ae37a2bdaf3eb53858e54e6cc4986c62528.camel@intel.com>
	 <ZliUecH-I1EhN7Ke@google.com>
	 <38210be0e7cc267a459d97d70f3aff07855b7efd.camel@intel.com>
	 <405dd8997aaaf33419be6b0fc37974370d63fd8c.camel@intel.com>
	 <ZmzaqRy2zjvlsDfL@google.com>
	 <5bb2d7fc-cfe9-4abd-a291-7ad56db234b3@intel.com>
	 <ZnGehy1JK_V0aJQR@google.com>
In-Reply-To: <ZnGehy1JK_V0aJQR@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB8492:EE_
x-ms-office365-filtering-correlation-id: 30b4f0a1-67ee-44e0-723a-08dc8fe4b8e0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|1800799021|376011|366013|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?ODZ1dTRZckZVL3FzWVF1Wi8wUm5YMFI3aWhUczJ0R29GTG1RZ01BODh6Qnp0?=
 =?utf-8?B?c3BUVTY5UEVxeDVEL3lOSU9xVzMzUVN5MVhvMVlDenNLc2Ixd1hkQ3dVeUJC?=
 =?utf-8?B?T2NzSXdZNnQyaldwWHlPbkhrUTQzSDdSYnZjWmNOeUNGTS96UlR5SXNPSDdY?=
 =?utf-8?B?c1h4aUVhQ2t0K1o2M1NsdUc0T1l2NE1IMmRwaFRnNUlEWElMSlA0cTd0OHBC?=
 =?utf-8?B?a0lmTVVXZy9waC8xV24rbExBNDUrbGdqZkYvdXp5U2tOT0pSSFZwSXlVZU81?=
 =?utf-8?B?MjI5a2p1aFNzTDE4MUxVMXNtTDJldVhsM1dCcFBMSGwyZ0J0dUhtR1NodmhL?=
 =?utf-8?B?YTJKVVJudDloWXA5TmZqRE8xc1RyaUNEZFo1cmpyRVZ0a3Z2ak5henU0OVhW?=
 =?utf-8?B?NUlQZW5uUFFxU1RXc3dKYVFITWo3TWJhOGVoMEF1cFJzUFB4aE8raHFHMlE1?=
 =?utf-8?B?TFNoemszeFdiYUtaSzNscXdWdG96TGU4M0dUdmYxK2R4NFkwa3V2WGI0UzVw?=
 =?utf-8?B?ZUdFRUVZUXBHUUlKeGZLdkhkQkx6N3JacktOK2w3WXdzMzVnZ0hXWlh0OVo2?=
 =?utf-8?B?RkFLZWpwUGpES0pXNWRKRTcrdTFvMTdSa2ZXUGhvOXp4OTBTV00xYkRQZjJN?=
 =?utf-8?B?ZGxNSjI5Nk1BdExzY0ZtTitkWndCY0hma0NEZVd0YzJPS1h3aDcwTmZkSzBQ?=
 =?utf-8?B?SWw3ZWJLMDYyM2tBeWlucTdOS3pmRmFQcHQ0R3AxaVdWd3ZRRmlIRjBidHNY?=
 =?utf-8?B?aTZyNWp6MlI0akkyUE9xcDFqa0diTkNxNzV4Q2hFUVQxRTBKQi9neklmRVNU?=
 =?utf-8?B?RUJmRVJ6UXkwY0xsQ2NueWFvVUYzYlJRNDljZ0tXbjBrYUZsWXdDYm1sa0xp?=
 =?utf-8?B?dEtsNUJqOUZGbngzSzAraVJZOE9iRTI5RnppNEsrZXBxNkttZ1lqUlJjMDJN?=
 =?utf-8?B?NEVRMVBMVmY3U2JWZ25zT3RUSy9IYUdrSUs4OGJEOUhxaHgyNnBBcHpscU9X?=
 =?utf-8?B?RUtxQ3NJdXpyUjRudlpxczZXZjdGYVBsaGhkaFJ4TTBmclNPY1dKa3h4THZv?=
 =?utf-8?B?ekpFbEcrMGpFajNlUWFaNnJTRUloSUdyaDdRUUlmLzQ4eHhCOXM5SHRENDVC?=
 =?utf-8?B?WWgrbkFDcXVsWi83eno1MCtwMDNNZEw4Z1lxTEh2RGFJZGhadE44Nm80dzN1?=
 =?utf-8?B?V3RDSG1IcEdjbVN0Vi8zZkdZcmxuR3o0V1FZUGI4N3ltdFJxQXFjTTlVbDY3?=
 =?utf-8?B?SFN0UHZ0RDhzMXJ6YWVyUzR1VFFWSjd4SUIxRmhjTFNFbVNnTjE1TXlTd3Fk?=
 =?utf-8?B?Q1h4OTVkMkczRVlJU1d4VlpGQS9KZkpOMm1GdS8zVDRBNFVEcmVFS2dWZHNF?=
 =?utf-8?B?OUlPMHFXRUxHSkVkVHhNQUlQOUZhWEhRWXdVNVhyS1NBVURIWkRLTGNLZ203?=
 =?utf-8?B?MFJWNmhZb1BjVWx4bVVFZnBJb3lZSHpKKzNjcll1MUtBRU4zY3l2UG5PNW9R?=
 =?utf-8?B?WHJKNndXYm5nRWVhNTF0QVA0SXFtV0lHbXMxemp1SUIwc0JncEhndS9wQ3h0?=
 =?utf-8?B?S2Q1R2dwdW11Y1FtUXpEUU5kWmIvSjRiRVMwQmJDakpnTXBLVDNDU3FHSWRa?=
 =?utf-8?B?clNTa1RLdklYSEk1NXJqWEFCZm14NmFucFNqenFkN0docFc3cEhFajBubDlq?=
 =?utf-8?B?UFllT0dHdnc5Rm5QVnJiZ3R4TSs0OXJ3K3hFbTF5MFl2UXBHd1RCdnJodVpW?=
 =?utf-8?B?QW5RK3d2cFVsaS9JOHMrN3lZU05DVENJN3cyNnhJbU5URHRzRGVDQmJGS29v?=
 =?utf-8?Q?KnxyMFa7Yx9Z1gmCZdRCbMKs9iSJr1sLwNpnE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZEs2NDVGNlJaU1V4R3NlenVWMjg0dWgvY0RySzZMQ0dseEZRK2JCdm9GWVQ0?=
 =?utf-8?B?cTNReG9hZG9OT0lxcjNFK0pFbEZxUk9OTVgwSFRtYUhaaTRXQmhDL1luelRq?=
 =?utf-8?B?NG01ZmI4bVY4M0Ywdi83WktCbnA4V0hEcFQxeXg4bnZvOWpKUjVoOXVZWUxD?=
 =?utf-8?B?akFkRnJTZnIwbk4yWHVrbHI4TVNJRmk1NytVRDE0Yk1sSitxZlhIQThKZ1pU?=
 =?utf-8?B?RGY5ZUVBMFRHMHh2THBFS0I2RUZQbFdTajRQcDJyMllQRFRNRDRMZU9RT051?=
 =?utf-8?B?c2dPbGMxRTEzZUV2UUNZQU12cjdXTytyazRJODQ2QzNpdldPV2ZZWDAxM1hz?=
 =?utf-8?B?SlNNL2dvdUp0eE40bHI0bnhtOGVUT3dsT2hWdXFwV3B4TEljdkhaaERuMm9o?=
 =?utf-8?B?cDIyY3JGUzJucG4rU0paMzRmTXdiN1NRc29teVJ4K0o1di9iaEpWRXB5Zmg4?=
 =?utf-8?B?STFTL3VnYUxHN3pEU2p3TVFsVy8zQU4yaG1POTJkU2ZTaWJoSjZMUXkxR3Fn?=
 =?utf-8?B?MFFlR01OdlNnSnFESkZMZVJEOWgzaFhNMWI4TmhOSW5FRHVNU0ZVc2J4YnpI?=
 =?utf-8?B?TEFHaXgvSjN3WC81eHplaTNGSFVUR3ZWaXdSajQ5bGhNb25zUVZ4dU10MXBp?=
 =?utf-8?B?MXhZT0w5V09TY1RDTWtiMGJrejBTZkpYSEwvbytxOWVNLzlvY3U2K2dqMC9X?=
 =?utf-8?B?V2VvWmNGdjY3L3hLTEZCK0NFT3dGMEkvS2VlT1REeEQ5TFJqWUF4MjRRTk1O?=
 =?utf-8?B?Y3hrNDhwd3lBQ2RRaUtQNVdGM3dsa3dKTDd2TEFXa1dSbkk0VjhoU2RMNVVW?=
 =?utf-8?B?a2NOZmhHcmJEMHY4a2pBU2RHbWxRcGR3L1F1V3VQeWI2ZmJQRW13VWdYYmp2?=
 =?utf-8?B?blFKNWZFbXhYN3FRbTZGa0h0OXJIWkRIUjRPMUd4dklwRUU4YTdJVkMzMzg3?=
 =?utf-8?B?b0cvVXB3cGZTdHdoZVAxZnlDOFRET1ZzdFZSYzZvYVhieDhRTUw0T1MzV1Bk?=
 =?utf-8?B?UlE1OVdxSmR6OUxWSys2STR1ZC9XWnFYMkJVNkdwanpKWkNEN0RhVE1PbFJQ?=
 =?utf-8?B?MmF2UzgvVDFNZkxpWlE1ck0xeGtmYjNTVWJkWFdvRWR5V2gwS3JET3lLa2xt?=
 =?utf-8?B?cVZjUVNSK25xYUJ5SGVGNXcveGV3UjdQTDlZNDgzQ0lzRUtFOUU2ZFVvL1lt?=
 =?utf-8?B?YUdablRKM3F3akpyQk9iYXpSa0VpS3VucDlNd1JPcjh3UTNEN0x4d0hMVnZa?=
 =?utf-8?B?c09zQitkUWlKVDlLLzdoVzNUSXBHdVEyZEE2V0Z2M3NQYmlVbkVrK0RJNTAr?=
 =?utf-8?B?NnBnZkdib1hkR1lIbFVKelh6Z3VibDE5YWtGL1V1ZjBxT1Q5LzdGZ0s1ek5v?=
 =?utf-8?B?eVI1UjllT3dBeWs5V05iSzVOMGk1TG9Pc213SjhWa1F0cW10WHA4YUQ1TGpY?=
 =?utf-8?B?aGsyc3orR3B0SnVxejY0NHpDQVZ2RWgrTzFEZlRiazd6czVXdlk0dXBKL3hx?=
 =?utf-8?B?enFRMktYbmxXdFRacmdqUE9XZk15SmhFZ2RhQ3JLM0I5dUNHVENaNkNFVEtF?=
 =?utf-8?B?ZnlyZEplbjlqZ1krN2JFVEFaWlEwWCtKd09SNloxTTVvYTRQb2hDa0s1RlVk?=
 =?utf-8?B?dDNKd1hCOTRwMWFVeXV4Z1Zpc214R21wcjZNSkpVUVNCZDdkQmlpaGdINlJy?=
 =?utf-8?B?dWZZUDdUbFR0OEkxS0ZpMFc5a1FlaGlwMElMTUhMN1FkVkNsYjlCZXpPYjhn?=
 =?utf-8?B?WlpqQ1pjTmorNElJSSszV1BGOTY5K1ZTdlZnU0ozYURPNkdEZ1NkaDJQRkpD?=
 =?utf-8?B?alY3dmE4QXU4YVFHQW5QTjFtWWl6b3VHUHYvdTdIMXFMUHd0ZmxtS2YrV1Jw?=
 =?utf-8?B?ZXgwYnRPMGZSc0dDbGUxNFNmN2lMSFpiWWNiWkl1NHB5VDR5UFRZU1B1MGFD?=
 =?utf-8?B?RDkvMVFPM3F3VnJvbHlaY0ZIU0g5M3VYVUJFaVIwQ2VmcFE5Nm1GWk0vZEVQ?=
 =?utf-8?B?VEhDYlhzVk1pL3krQ2RQbkFvbnpkS2pibTdEaUVpZXBNZ1FHMUlmc3d0bUVN?=
 =?utf-8?B?SUlHTEpCOXhlL1pMKzA3YVVtaEx2QlM0UmtpeVVTamxOMWdmNXM4a0hnTm9E?=
 =?utf-8?Q?umE4xc8KuxsM5/r8Vptm33OfK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D55DD91D03D7274EA0918ABD2AFA62FB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30b4f0a1-67ee-44e0-723a-08dc8fe4b8e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2024 22:19:29.6538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yqfTdpjKjsdyR8bcEir+VW8MO6On+Swf265iGrfoQYQ1gONbf+Bmni1l347kdJM80h73Br+CyIbDg+BWharAqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8492
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA2LTE4IGF0IDA3OjQ5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEp1biAxOCwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIDE1
LzA2LzIwMjQgMTI6MDQgcG0sIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gPiBPbiBG
cmksIEp1biAxNCwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gPiA+IC0gVGhlICJtYXhf
dmNwdXNfcGVyX3RkIiBjYW4gYmUgZGlmZmVyZW50IGRlcGVuZGluZyBvbiBtb2R1bGUgdmVyc2lv
bnMuIEluDQo+ID4gPiA+ID4gcHJhY3RpY2UgaXQgcmVmbGVjdHMgdGhlIG1heGltdW0gcGh5c2lj
YWwgbG9naWNhbCBjcHVzIHRoYXQgYWxsIHRoZQ0KPiA+ID4gPiA+IHBsYXRmb3JtcyAodGhhdCB0
aGUgbW9kdWxlIHN1cHBvcnRzKSBjYW4gcG9zc2libHkgaGF2ZS4NCj4gPiA+IA0KPiA+ID4gSXQn
cyBhIHJlYXNvbmFibGUgcmVzdHJpY3Rpb24sIGUuZy4gS1ZNX0NBUF9OUl9WQ1BVUyBpcyBhbHJl
YWR5IGNhcHBlZCBhdCBudW1iZXINCj4gPiA+IG9mIG9ubGluZSBDUFVzLCBhbHRob3VnaCB1c2Vy
c3BhY2UgaXMgb2J2aW91c2x5IGFsbG93ZWQgdG8gY3JlYXRlIG92ZXJzdWJzY3JpYmVkDQo+ID4g
PiBWTXMuDQo+ID4gPiANCj4gPiA+IEkgdGhpbmsgdGhlIHNhbmUgdGhpbmcgdG8gZG8gaXMgZG9j
dW1lbnQgdGhhdCBURFggVk1zIGFyZSByZXN0cmljdGVkIHRvIHRoZSBudW1iZXINCj4gPiA+IG9m
IGxvZ2ljYWwgQ1BVcyBpbiB0aGUgc3lzdGVtLCBoYXZlIEtWTV9DQVBfTUFYX1ZDUFVTIGVudW1l
cmF0ZSBleGFjdGx5IHRoYXQsIGFuZA0KPiA+ID4gdGhlbiBzYW5pdHkgY2hlY2sgdGhhdCBtYXhf
dmNwdXNfcGVyX3RkIGlzIGdyZWF0ZXIgdGhhbiBvciBlcXVhbCB0byB3aGF0IEtWTQ0KPiA+ID4g
cmVwb3J0cyBmb3IgS1ZNX0NBUF9NQVhfVkNQVVMuID4NCj4gPiA+IFN0YXRpbmcgdGhhdCB0aGUg
bWF4aW11bSBudW1iZXIgb2YgdkNQVXMgZGVwZW5kcyBvbiB0aGUgd2hpbXMgVERYIG1vZHVsZSBk
b2Vzbid0DQo+ID4gPiBwcm92aWRlIGEgcHJlZGljdGFibGUgQUJJIGZvciBLVk0sIGkuZS4gSSBk
b24ndCB3YW50IHRvIHNpbXBseSBmb3J3YXJkIFREWCdzDQo+ID4gPiBtYXhfdmNwdXNfcGVyX3Rk
IHRvIHVzZXJzcGFjZS4NCj4gPiANCj4gPiBUaGlzIHNvdW5kcyBnb29kIHRvIG1lLiAgSSB0aGlu
ayBpdCBzaG91bGQgYmUgYWxzbyBPSyBmb3IgY2xpZW50IHRvbywgaWYgVERYDQo+ID4gZXZlciBn
ZXRzIHN1cHBvcnRlZCBmb3IgY2xpZW50Lg0KPiA+IA0KPiA+IElJVUMgd2UgY2FuIGNvbnN1bHQg
dGhlIEBucl9jcHVfaWRzIG9yIG51bV9wb3NzaWJsZV9jcHVzKCkgdG8gZ2V0IHRoZQ0KPiA+ICJu
dW1iZXIgb2YgbG9naWNhbCBDUFVzIGluIHRoZSBzeXN0ZW0iLiAgQW5kIHdlIGNhbiByZWplY3Qg
dG8gdXNlIHRoZSBURFgNCj4gPiBtb2R1bGUgaWYgJ21heF92Y3B1c19wZXJfdGQnIHR1cm5zIHRv
IGJlIHNtYWxsZXIuDQo+IA0KPiBJIGFzc3VtZSBURFggaXMgaW5jb21wYXRpYmxlIHdpdGggYWN0
dWFsIHBoeXNpY2FsIENQVSBob3RwbHVnPyDCoA0KPiANCg0KQ29ycmVjdC4NCg0KPiBJZiBzbywg
d2UgY2FuIGFuZA0KPiBzaG91bGQgdXNlIG51bV9wcmVzZW50X2NwdXMoKS4gwqANCj4gDQoNCk9u
IFREWCBwbGF0Zm9ybSBudW1fcHJlc2VudF9jcHVzKCkgYW5kIG51bV9wb3NzaWJsZV9jcHVzKCkg
c2hvdWxkIGJlIGp1c3QNCmlkZW50aWNhbCwgYmVjYXVzZSBURFggcmVxdWlyZXMgQklPUyB0byBt
YXJrIGFsbCBhbGwgcGh5c2ljYWwgTFBzIHRoZQ0KcGxhdGZvcm0gYXMgZW5hYmxlZCwgYW5kIFRE
WCBkb2Vzbid0IHN1cHBvcnQgcGh5c2ljYWwgQ1BVIGhvdHBsdWcuDQoNClVzaW5nIG51bV9wcmVz
ZW50X2NwdXMoKSB3L28gaG9sZGluZyBDUFUgaG90cGx1ZyBsb2NrIGlzIGEgbGl0dGxlIGJpdA0K
YW5ub3lpbmcgZnJvbSBjb2RlJ3MgcGVyc3BlY3RpdmUsIGJ1dCBpdCdzIE9LIHRvIG1lLiAgV2Ug
Y2FuIGFkZCBhIGNvbW1lbnQNCnNheWluZyBURFggZG9lc24ndCBzdXBwb3J0IHBoeXNpY2FsIENQ
VSBob3RwbHVnLg0KDQo+IElmICBsb2FkaW5nIHRoZSBURFggbW9kdWxlIGNvbXBsZXRlbHkgZGlz
YWJsZXMNCj4gb25saW5pbmcgQ1BVcywgdGhlbiB3ZSBjYW4gdXNlIG51bV9vbmxpbmVfY3B1cygp
Lg0KPiANCj4gPiBJIHRoaW5rIHRoZSByZWxldmFudCBxdWVzdGlvbiBpcyBpcyB3aGV0aGVyIHdl
IHNob3VsZCBzdGlsbCByZXBvcnQgIm51bWJlcg0KPiA+IG9mIGxvZ2ljYWwgQ1BVcyBpbiB0aGUg
c3lzdGVtIiB2aWEgS1ZNX0NBUF9NQVhfVkNQVVM/ICBCZWNhdXNlIGlmIGRvaW5nIHNvLA0KPiA+
IHRoaXMgc3RpbGwgbWVhbnMgdGhlIHVzZXJzcGFjZSB3aWxsIG5lZWQgdG8gY2hlY2sgS1ZNX0NB
UF9NQVhfVkNQVVMgdm0NCj4gPiBleHRlbnRpb24gb24gcGVyLXZtIGJhc2lzLg0KPiANCj4gWWVz
Lg0KPiANCj4gPiBBbmQgaWYgaXQgZG9lcywgdGhlbiBmcm9tIHVzZXJzcGFjZSdzIHBlcnNwZWN0
aXZlLCBpdCBhY3R1YWxseSBkb2Vzbid0DQo+ID4gbWF0dGVyIHdoZXRoZXIgdW5kZXJuZWF0aCB0
aGUgcGVyLXZtIEtWTV9DQVBfTUFYX1ZDUFVTIGlzIGxpbWl0ZWQgYnkgVERYIG9yDQo+ID4gdGhl
IHN5c3RlbSBjcHVzIChhbHNvIHNlZSBiZWxvdykuDQo+IA0KPiBJdCBtYXR0ZXJzIGJlY2F1c2Ug
SSBkb24ndCB3YW50IEtWTSdzIEFCSSB0byBiZSB0aWVkIHRvIHRoZSB3aGltcyBvZiB0aGUgVERY
IG1vZHVsZS4NCj4gVG9kYXksIHRoZXJlJ3Mgbm8gbGltaXRhdGlvbnMgb24gdGhlIG1heCBudW1i
ZXIgb2YgdkNQVXMuICBUb21vcnJvdywgaXQncyBsaW1pdGVkDQo+IGJ5IHRoZSBudW1iZXIgb2Yg
cENQVXMuICBUaHJlZSBkYXlzIGZyb20gbm93LCBJIGRvbid0IHdhbnQgdG8gZmluZCBvdXQgdGhh
dCB0aGUNCj4gVERYIG1vZHVsZSBpcyBsaW1pdGluZyB0aGUgbnVtYmVyIG9mIHZDUFVzIGJhc2Vk
IG9uIHNvbWUgb3RoZXIgbmV3IGNyaXRlcmlhLg0KDQpZZWFoIHVuZGVyc3Rvb2QuDQoNCj4gDQo+
ID4gVGhlIHVzZXJzcGFjZSBjYW5ub3QgdGVsbCB0aGUgZGlmZmVyZW5jZSBhbnl3YXkuICBJdCBq
dXN0IG5lZWRzIHRvIGNoYW5nZSB0bw0KPiA+IHF1ZXJ5IEtWTV9DQVBfTUFYX1ZDUFVTIHRvIHBl
ci12bSBiYXNpcy4NCj4gPiANCj4gPiBPciwgd2UgY291bGQgbGltaXQgdGhpcyB0byBURFggZ3Vl
c3QgT05MWToNCj4gPiANCj4gPiBUaGUgS1ZNX0NBUF9NQVhfVkNQVVMgaXMgc3RpbGwgZ2xvYmFs
LiAgSG93ZXZlciBmb3IgVERYIHNwZWNpZmljYWxseSwgdGhlDQo+ID4gdXNlcnNwYWNlIHNob3Vs
ZCB1c2Ugb3RoZXIgd2F5IHRvIHF1ZXJ5IHRoZSBudW1iZXIgb2YgTFBzIHRoZSBzeXN0ZW0NCj4g
PiBzdXBwb3J0cyAoSSBhc3N1bWUgdGhlcmUgc2hvdWxkIGJlIGV4aXN0aW5nIEFCSSBmb3IgdGhp
cz8pLg0KPiA+IA0KPiA+IEJ1dCBsb29rcyB0aGlzIGlzbid0IHNvbWV0aGluZyBuaWNlPw0KPiAN
Cj4gV2hhdCdzIHdyb25nIHdpdGggcXVlcnlpbmcgS1ZNX0NBUF9NQVhfVkNQVVMgb24gdGhlIFZN
IGZpbGUgZGVzY3JpcHRvcj8NCg0KTm90aGluZyB3cm9uZy4NCg0KSSBqdXN0IHdhbnRlZCB0byBw
b2ludCBvdXQgaWYgd2UgcmVxdWlyZSB1c2Vyc3BhY2UgdG8gZG8gc28sIGZyb20NCnVzZXJzcGFj
ZSdzIHBlcnNwZWN0aXZlIGl0IGNhbm5vdCB0ZWxsIGhvdyB0aGUgbnVtYmVyIGlzIGxpbWl0ZWQN
CnVuZGVybmVhdGggYnkgS1ZNLg0KDQpXaWxsIGdvIHdpdGggdGhpcyByb3V0ZS4gIFRoYW5rcyEN
Cg0K

