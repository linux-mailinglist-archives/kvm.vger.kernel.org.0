Return-Path: <kvm+bounces-17710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33E868C8D7E
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 22:59:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD44C2843A5
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 20:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4F0C140E30;
	Fri, 17 May 2024 20:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QyV/5wu9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDB81A2C1E;
	Fri, 17 May 2024 20:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715979528; cv=fail; b=EPE9h3PZzMS+UdKxwmqpC3egDPUuNY/sUUvfWFLwyXBhIdjm6I8TTQXDmvBP48ZHIJT8LCNEOUQM4rIg7fztcJg8bzPrMypRiu03S/tHGliwd2Ye4YMNDlMbDjE9lzDYPo670aGM/LR1RYZsNnYWc80U7lEpbxRHzJjUOf1a7n4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715979528; c=relaxed/simple;
	bh=2o92fYxz3fNaKxyKbzOOh/I9ZxJaUtwSCChqeJ+Dt/A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XUl3MXLsZ/raFQNr3q8f1z1E5bZ1EO4gY3Z/kpwmgxkKqLUDdM5OZXqpsIo1eSSePYZf6WWlRhre7lSrzgelSW2Jlu/fIeGyM1Gmq5UNwd8v4ZTVJAW1BtvFJOGZY4tL2YIt/GVL1udQyLkBwAhAi0oTW9MVRRCdByO6BjgMJ8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QyV/5wu9; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715979527; x=1747515527;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2o92fYxz3fNaKxyKbzOOh/I9ZxJaUtwSCChqeJ+Dt/A=;
  b=QyV/5wu9wOTbg4KD83+49T8Tazz32KuiuMRZ3fTTZVHJP8k8lymGc3Nd
   PWe+8vnijF+h2nKh8tT8zLCTNHaezmIt137psfQ3bx3xIuF9vsJaG1vZL
   wZfsBZXfKHnGb9xKUlrdMx/BpFHP1axB2K8d9uoUcm3qoyXeTx7OvBvNN
   JMGbL9dcC9zUcN2TVXCo/EC+Gr/YO/U1hIs5GOuVy2hk6Xyxk9uHysIC6
   1zylcGrmcRZZ9V4yxuRiD7oZxD6shdGzsui9MQFGKRzGQS89qB4nxpzlr
   lofJ7VMgPRVEccNO08Rai0fohetc5Zj8mpjKx0iM12XCUrmoZAM+4CzUF
   A==;
X-CSE-ConnectionGUID: +IDNzmE0SsiWXMtat4xuIQ==
X-CSE-MsgGUID: iiAD6Z4KRi2+RRzfyzYWzw==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="11980496"
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="11980496"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 13:58:46 -0700
X-CSE-ConnectionGUID: TTZkMp7/RtSpdqLYOythFQ==
X-CSE-MsgGUID: X/SSeHcBSkS4xEuFq0qchQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="31750420"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 13:58:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 13:58:45 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 13:58:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 13:58:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hGZqoCaD6q7AC7M888jbmnEofFZiWBn7SPd2mTvjTNx3rqBd26a3Ctxe6XTS8gc4kxAO7zlKiVtSgKK+bTeA6zhcmTwOIICS8UTOAC+ozaMT7whQ0Lt3vgasx6QfNq9ZY8q5zxLsAiqbSxJlhKyAHgTLVHL2uClF0QIx/ium1RfzXSwNdlkl2kV6fGXycvPK65wyjOKL1hEKhAtUItQHp/TFkBD8hh6BAVp2Rs0SnMqZS0/oConlvbYDPAx06UeOwiF2Fjnufu0vjIkRNqh3LcQrl/yHIpi+rknEeRtCCCnIRAPbXLZ9T6RuGzoRjHTyPKenFhhb/5xO85zclATEOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2o92fYxz3fNaKxyKbzOOh/I9ZxJaUtwSCChqeJ+Dt/A=;
 b=O3WbLYu6ThtV7dvsrA9kTvYzJ/ZKOe/VzbJGLyN1J+hE56vIUjcD/TagoSVxbJle7HoTuw36Y/XeSeXPf5H4XQU+1x4fyMTPBumB00nk1PaYhNCrUyJEi6qLwSupUKwwrxkmn7ykszwu7Cuy0RIQj5fwJS8iqmPvmdrxW7QA9l1Wzn3Lk72sTDCGQ9eg+1aELFJJ12tflYh7jXmv9RlTTQXleYWQn6Uvu76e6Ld/GdSpJFBDBxpK+iZYKka9JWiBVgOOsGfQMr995Kogn3LZte3ag9tBw8bj2SCmAk+5l4mPXQEsxItVz1K0+iY5nMp13L8otrcz15jQVRHZiYItrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6140.namprd11.prod.outlook.com (2603:10b6:930:28::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.30; Fri, 17 May
 2024 20:58:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 20:58:40 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "sagis@google.com" <sagis@google.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 05/16] KVM: Add member to struct kvm_gfn_range for target
 alias
Thread-Topic: [PATCH 05/16] KVM: Add member to struct kvm_gfn_range for target
 alias
Thread-Index: AQHapmNaKWpK4fhDo0OPqDatKGdC/bGb7TWA
Date: Fri, 17 May 2024 20:58:39 +0000
Message-ID: <329338c097ea7bb9b694fa887c91e808b8b2d2ec.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-6-rick.p.edgecombe@intel.com>
In-Reply-To: <20240515005952.3410568-6-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6140:EE_
x-ms-office365-filtering-correlation-id: 0f567a04-5f2e-4047-0f4b-08dc76b42102
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Qk5vUlc2M3pIb3ltUkVFY21wWDFtaDU5OGVWd3lQd3JzYnh5VS8wbnlJdGZZ?=
 =?utf-8?B?OThXUXBiaDNlTXRZZnNybTlUbFEvSHdqSUp5eTAvR090M2daRnNCZTk4VkNP?=
 =?utf-8?B?SzVCYUFFQ2ZJT2ZsbmphTGZlK2pHL3hBNmNaNEFONFo0dTR1NG03eFJrYmFx?=
 =?utf-8?B?VUlCV0pvQ1ViOHNOMnRzUVZKWENLK1hYeExYZEJPSW1OY2MyYzlHUWZudldI?=
 =?utf-8?B?aElPNlNTWWE2L2ZvR29KZ1MrdWRUVVh0ZWh6VXdnRGJ0c3Fxa3FIZnJVaUVK?=
 =?utf-8?B?QUptVFVtazljWit1Y1RSVVB1RTBabkQzUmlBNmhBd3NWeDRySzNrYUZ4dzFM?=
 =?utf-8?B?ZEVja2hUeThJY0RSR1Rmek5Zb2EzbU4yWDJoRlRmU3Z6Vmx1MWNWdGxKUW9L?=
 =?utf-8?B?YUp5OW1pVm11a01mUm9DL2tiMmpiTnE5MUxrWURSM3lyWjNqckY4blRXTWky?=
 =?utf-8?B?dmJENnQxUmQ1VVBPMHNERkhlelZKcitjeVdJLzBuZTZndWIyYmcwcmhMMzVk?=
 =?utf-8?B?REZuSldLbi84am9IM0ZyVUVIVlRhaUJ6ZjJpNHM0a2xpWEJSWnRVSW9qYStw?=
 =?utf-8?B?Wm5laGhHeVh1cGxBSzRQMjlYUE05WHM3cEJseHRiVjg2dVJkdVAwSDVYK0Nl?=
 =?utf-8?B?Q256RXdZWTBMYVp5aHZqdGZDMGYrc3djZmVmbHdLZm5EOVA2dElibkNlOW9t?=
 =?utf-8?B?RE1WNkRZQmdKTEFZVlk5MzFxcFNSUWFVMnJTUVlVUm5vZ2tFeVV3TVVHRXRK?=
 =?utf-8?B?VGZ5V212ZGIveWg5aDFjTllDcUJQeVgwWE1PaDRsajZsY0FnTmhoMzBpZW51?=
 =?utf-8?B?Z2lBM0EyYXp2cWNnWGZzbzFSZUM5WjdFNFhwck1vYmZzNDJXdEhjMFhSMnVL?=
 =?utf-8?B?d0w2VjE2UUs2ekxHYkkwYk9pZnFoTG04Lzk4cnZUTEw0c0hHN3FwNjZLMlhw?=
 =?utf-8?B?T2pZWjExSlJMc0lrb2pVK1BidzFuZERUdVErNkdNWVowQUlldVVKRjdmenB3?=
 =?utf-8?B?SDVBSVhXb01DaWVKUDdnaDZwMlBuL2ZJNXpSOXJPeHEyQ2Q2RFl6U1JJMjhK?=
 =?utf-8?B?Yzh4NzdROXArZ1poWTBrOHRtZG5TRTFPb0RhVExYYVlMZmw5QURZSU80dDBU?=
 =?utf-8?B?NnFqV2xBSVJJVDh4YjJRVm9DUkdFd2VYbTBwNmdsUmVlcGlUZVE1U3BOUEdT?=
 =?utf-8?B?SUJKRzltTjE5aFcyd3dGaTJVK2dCL00xVDBHZERNa09Wdndac0oySi91b2ZY?=
 =?utf-8?B?eVJUZ2xMdnBCK2pPV0JsNnppMDJBOXNicW5mTStGVk11QUVaZEIwektrTzVO?=
 =?utf-8?B?WCtuR2lienZYd1czSWFpSGJTang1c0JIMHlOVUpnci9XNG03YktsNjJJKy9u?=
 =?utf-8?B?MFRyaGZNdy9ON2M2K000NkNENGxMcjVXVWtrZFJjcUg0K1gzUWdPcXBwUllh?=
 =?utf-8?B?QTA1bi8zM3RqRG5EMEVOTXpuc004TVlKanJLK2UzK3dkR2Z5NkdTT2hpYVVB?=
 =?utf-8?B?L2ljVHVyZGVFWjZCMWtTZnR6ZEpFRUc4eFFrMjhVUnJaM0JHVDJRZVRLTWpP?=
 =?utf-8?B?Risybmd1Mi9MUCsxL1R5MVRRTG1vQ0YvZ2g4UlRBRklaWW1ZNjhmK3dCT0lK?=
 =?utf-8?B?NnNXL1oxZnZzdHZzTDZyVUxRNDVoVWdUbU51dTZuUlRsY3VURTdVYmhMY2N1?=
 =?utf-8?B?NnIrVEpLalkzenFLeWVGTzJVcnMvS1VzZXlzZ0oydWZONlhJcHlNMk43aUxz?=
 =?utf-8?B?eFpYNk9KWGxxRFlNNzIyN3hoK1ArNDlVSDh4RzVOY1pCMmk0YjVzSi9NTktG?=
 =?utf-8?B?NDhnL2lsemRic0NXbFRSZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnQ5TDZQR1RUc1J6NDR3d1dZNnQ5cVFWOW8xck8xYmhjb1pPZTEvK3dFUmtT?=
 =?utf-8?B?Q0VIZTVGcWlnUGZVMzE2WDgvdi9abE5nSisyVDUyNGpwWEV3V0Vma2ZFbEkv?=
 =?utf-8?B?cmlVVU9Kc0JzeHJFY3VzTnpNMW1rZjBTb2VXNWJKanR3QnRoemlHNXVlRUpa?=
 =?utf-8?B?R3JvNktyUFhJZVc3bnI1djhWd2IyZENCamt1VEwvVzhvMDU4TWIwOWhYNktT?=
 =?utf-8?B?ZGFROXI1VzNOTGJtL1hMOGJHN0hCQ3lVVElaVzd4T2RVbDVpUDN6UUZaK3hE?=
 =?utf-8?B?UDNZYlRWM1AwaC9zQ0FKaGpPN0tZWUh3S2oweHVlUE9lYmtpQ0JhelFRdDcx?=
 =?utf-8?B?TXI2MCtjOU0vc3dRRTAyenpjUkg3VS83TmxjYXl2WnZ4NEJvYkY2RExrMFF3?=
 =?utf-8?B?SjNsTERrMC9Rd2p3M3VCQVF3cmFkeXdqOVZ4VmxIWFhXcENwVE1OazRFN240?=
 =?utf-8?B?MXFEeUZiN0MrSU9UajRZTEtnWnhodEViRE5XUkFzbGVEdGIyWnNUY016UkZC?=
 =?utf-8?B?TG5nVTRESWVZQ2EzczM5SEU2Yy9FZ05aTHZOb0k3RmYxWWNaNzEzWEdraDlh?=
 =?utf-8?B?alhYNXhNNUxBNnJVUXg5VFdNK2k5Tll1ZExsc2dYOFlYcmRkSGY2ZEUxYzBn?=
 =?utf-8?B?T1RFcHc5ajJmbnA1Mlh3dit4VmpvNVo4MW9sRDIrWjVYbEFPbEZtNnFqdnh5?=
 =?utf-8?B?d2MzMy9zT1FsdjBob0dGVENTVmJrM1JEWnZYNmFDankrNHJ3ZlA1TmVuTk0w?=
 =?utf-8?B?ZGVqeVlKMGk0UVZGSDBrSEtCbWRUNGpRUENlUVlnQmlLTHh4VmV5WUpYWDRj?=
 =?utf-8?B?Rm1pUDFuK0lwM1dQNUlNQzEraGltUSs3Q0dIdW96Z01YellCYTl0L0lOckhs?=
 =?utf-8?B?bng1b0cxbWxVTkFiZ0FqSW1XVzVYZTY1MjE1S0hzcnp6V1dHbzJRakNQblZD?=
 =?utf-8?B?V0Ezcm1EUU1JMERPZEJUekNnQVlrWTNqKy9OUzQwSTVlb0Q0K3liSVVlcFlk?=
 =?utf-8?B?YWpNV2JBRUtnaUZnNFQ2SE11Z2Z2YzFweXZhbzB5ZVNFU1h0TG5DV3NhZWc3?=
 =?utf-8?B?OUo0UlN0elIzeU1HdC9paGRYYWhHbWFMQ04wMWNqNGxJSE85dXhzdkxRbUlh?=
 =?utf-8?B?ZTRmRnFLS0R1V0kyNnl1WDhhSElQRTlpVld5clhXdVNtcExoNEYxQ0g4SnNN?=
 =?utf-8?B?dHo3dlpxY1NGQjBpVkNyb1NUazlrNFBGeFJmamJFYzBiR3ZHVEkyek1teWJZ?=
 =?utf-8?B?S0FXaFJkTzJlMFBWemVCS3pKZ2RubS9JdHlaNUp3RGlQdUMxeDNPQlJRcjUr?=
 =?utf-8?B?amloSC8vdWZlNzZiNUhWMWlVMVd4QWo0UG5VQzdxckxENEFqdTJZaklEL3g1?=
 =?utf-8?B?dytSY3dyNEp5emVuOGx2cWFmdU1Qb0NwK2ptWFQrTkI1OUN0eXRGSjYrOUNt?=
 =?utf-8?B?dDdVc1NBWmJPemRaSXNHMWJVVmtxRktRa0xtVEVNVjhmdkVUWE1HWXRSOFJ3?=
 =?utf-8?B?N0haWWtBMExoRkFRVzVDRTZGR25lMmNONnMrclZZMWRjNW51djh3Smx0ZWsz?=
 =?utf-8?B?SHNFNG4rbDBXaXRTNjg4N3R3aXduZzBxZlVlc1FTOFFxREFkMm9FdWgwN2dr?=
 =?utf-8?B?OFdMMnkxcERRU1RjcC90YnkyMENOYUZLZTFTejFGRVY5WGhtR05udi8vT21E?=
 =?utf-8?B?ZTc4bWlqS2ZBczFHNVZSeldaWHBMblc2U3BWM0ZZMERpYi9vMjNncGtCZDNy?=
 =?utf-8?B?R2t1dGJoeEFhUUJOdW1UM0xJNlludEpnVG9jbXZrNjVUK3lKL21rVFVVNm9t?=
 =?utf-8?B?U0Z6TWxSbDJRNXUvVjNxenlkQVI3RXFQSHl3WmdCOXB0a3VZa20xbVd2N0tj?=
 =?utf-8?B?bzNJemM5RUhmNE01SkxFMkRkNDhoWTdlbEl0RSsxSHVuNGtDcEdYZGZWdXlN?=
 =?utf-8?B?TDdkNCs2Vmg5TWxQajE5VG9GN3dJUmdnVGRjSE1hRUNmMDhRVUpzTjJpTmRi?=
 =?utf-8?B?UHJaZ09VSENtbm5oZHA0RG84dE5Qc01XbG1XTFhnUFhGNnRoVzhJcHg0WWpW?=
 =?utf-8?B?ZFduMzdPYXg0ZEFTUVhocUx5VndkN2lWMHhGYUlFUTh0eGtremJmR0lKQ2Nq?=
 =?utf-8?B?T1kvZ0tSUjBNb1QxSDVpTkVRbjVyellXSUM2SzZEdkhHeHI0cmpKMG5IdXcr?=
 =?utf-8?Q?7lFKZhT5CXLYWOZUEcrDCno=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <448202A23A35F546A2CBB9C2A61FC793@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f567a04-5f2e-4047-0f4b-08dc76b42102
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2024 20:58:39.9176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D423WU6/xwR0Ley86SanZyQtoEYz73tKKkDibraZ7dQUx8Na4L428VoFbtce7R893c+CDecdO3KyyX7gcS+ApKJu9YVYUeO62VYsUSEo5jQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6140
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTE0IGF0IDE3OjU5IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gwqANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaCBiL2luY2x1ZGUv
bGludXgva3ZtX2hvc3QuaA0KPiBpbmRleCBjM2M5MjJiZjA3N2YuLmY5MmM4YjYwNWIwMyAxMDA2
NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oDQo+ICsrKyBiL2luY2x1ZGUvbGlu
dXgva3ZtX2hvc3QuaA0KPiBAQCAtMjYwLDExICsyNjAsMTkgQEAgdW5pb24ga3ZtX21tdV9ub3Rp
Zmllcl9hcmcgew0KPiDCoMKgwqDCoMKgwqDCoMKgdW5zaWduZWQgbG9uZyBhdHRyaWJ1dGVzOw0K
PiDCoH07DQo+IMKgDQo+ICtlbnVtIGt2bV9wcm9jZXNzIHsNCj4gK8KgwqDCoMKgwqDCoMKgQlVH
R1lfS1ZNX0lOVkFMSURBVElPTsKgwqDCoMKgwqDCoMKgwqDCoMKgPSAwLA0KPiArwqDCoMKgwqDC
oMKgwqBLVk1fUFJPQ0VTU19TSEFSRUTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgPSBCSVQo
MCksDQo+ICvCoMKgwqDCoMKgwqDCoEtWTV9QUk9DRVNTX1BSSVZBVEXCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoD0gQklUKDEpLA0KPiArwqDCoMKgwqDCoMKgwqBLVk1fUFJPQ0VTU19QUklWQVRF
X0FORF9TSEFSRUTCoMKgPSBLVk1fUFJPQ0VTU19TSEFSRUQgfA0KPiBLVk1fUFJPQ0VTU19QUklW
QVRFLA0KPiArfTsNCj4gKw0KDQpUaGlzIGVudW0gYW5kIGt2bV90ZHBfbW11X3Jvb3RfdHlwZXMg
YXJlIHZlcnkgc2ltaWxhci4gV2UgY291bGQgdGVhY2ggdGhlDQpnZW5lcmljIEtWTSBjb2RlIGFi
b3V0IGludmFsaWRpbmcgcm9vdHMgaW5zdGVhZCBvZiBqdXN0IHByaXZhdGUvc2hhcmVkLiBUaGVu
IHdlDQpjb3VsZCBoYXZlIGEgc2luZ2xlIGVudW06IGt2bV90ZHBfbW11X3Jvb3RfdHlwZXMuIFRo
aXMgbGVha3MgYXJjaCBkZXRhaWxzIGENCmxpdHRsZSBtb3JlLiBCdXQgc2luY2Uga3ZtX3Byb2Nl
c3MgaXMgb25seSB1c2VkIGJ5IFREWCBhbnl3YXksIHRoZSBhYnN0cmFjdGlvbg0Kc2VlbXMgYSBs
aXR0bGUgZXhjZXNzaXZlLg0KDQpJIHRoaW5rIHdlIHNob3VsZCBqdXN0IGp1c3RpZnkgaXQgYmV0
dGVyIGluIHRoZSBsb2cuIEJhc2ljYWxseSB0aGF0IHRoZSBiZW5lZml0DQppcyB0byBoaWRlIHRo
ZSBkZXRhaWwgdGhhdCBwcml2YXRlIGFuZCBzaGFyZWQgYXJlIGFjdHVhbGx5IG9uIGRpZmZlcmVu
dCByb290cy4NCkFuZCBJIGd1ZXNzIHRvIGhpZGUgdGhlIGV4aXN0ZW5jZSBvZiB0aGUgbWlycm9y
ZWQgRVBUIG9wdGltaXphdGlvbiBzaW5jZSB0aGUNCnJvb3QgaXMgbmFtZWQgS1ZNX01JUlJPUl9S
T09UUyBub3cuIFRoZSBsYXR0ZXIgc2VlbXMgbW9yZSB3b3J0aHdoaWxlLg0K

