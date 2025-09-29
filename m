Return-Path: <kvm+bounces-59018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC8FBAA145
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:58:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 207B33BC76A
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F26930CB50;
	Mon, 29 Sep 2025 16:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JSYd0F4c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F81BCA52;
	Mon, 29 Sep 2025 16:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759165119; cv=fail; b=q3OUlqiwzkQad+jtmpfpEavHfu4CVpflZCRsi83Ot1un2zjyLJJQsu+Hrp9JvjfqyiaGX6GDQtmaT372/Z6Lq/YAQfbUEmn5Rm+8XpsTXBJe8vhjwTR0nF/2f716/DIF2NALZSNyWdfBHMTk4+1IySWgD7d+xprElEtvW3MTGVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759165119; c=relaxed/simple;
	bh=E00E/uAD8AXUYbRhQtsECH8KBzPHZbx0jKhUUTyqSQ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RLgbeKqTjjzRV8SoTieoYgDTIiWcqR5g5wAWvlDbiHEislpE4SXSCupNG7HMEmodZHv/uYPuW01ZDo4g2iMsQSk6nu8puNNBpVAhZKuZBIyY7UYmwSiKFrDDJFVYWb6TV8/LIMYtV1FRoyzFJNoUzeGluLvJXIbgTZTt079+Dqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JSYd0F4c; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759165118; x=1790701118;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=E00E/uAD8AXUYbRhQtsECH8KBzPHZbx0jKhUUTyqSQ4=;
  b=JSYd0F4c9/v0jswAulZjVsvTo8ygb1EcKGfQFOZmv7ZXioqaV/7Qx/gf
   NFQdqsY2AF6vtMAugBFazN2dQVFEALV2+5DA5anrcKB4SmC/U0C6uH72s
   s8qNi3h1AwmpBq4HmXEWgPEaSRBhmTZKWZsF6qKORSVbCLPG61lb87rac
   31Q/oAHeh9/F1/tuIdRRd3ojLP2YgjFPGQkQjXmz0hV/xrOrqfo6YVW3T
   BjPF6JclZsajohMnXyfffUBHbH3hlW/iMSp1JHPXE6k5Ln9fr9H5ZOt1k
   NxsXf3/1hcZwiFBbore8bl5KTXmSZ5XH5WYtVnI2fZBvD1DMFR57xrzGI
   Q==;
X-CSE-ConnectionGUID: WV4ixxEKS76jEIVSFOdHag==
X-CSE-MsgGUID: 0Fl8mIsxTeO9t715rvYVeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="72514114"
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="72514114"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 09:58:37 -0700
X-CSE-ConnectionGUID: nv1+3SFTRoOQ5hyRp4qsGQ==
X-CSE-MsgGUID: Aftm+UK7TtWhbVJ6gBAmOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="183469447"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 09:58:37 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 09:58:35 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 29 Sep 2025 09:58:35 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.8) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 09:58:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hNcnsMk6oCXE6jjJoWSrkoG5Bk/UhveqLKG9eUOMnnsUaVonyIYL+CsFWe2Jr4uYHas+43TBADTCOApwvkfDj9+rTCe4HAkBziPFG23w87QBNSci5ZbDxP7w0ZAcJH1EPq/pI43DYFGyn5lNmxqn2Lxzk82FCX4bQ1drqla+9lWNm5aYDQFaiJeS3jYwztRRGGpCQPD38CarsVl9sdwLkME8/tQ4BubY4XTiX07P8gmsHMCym07KFCuqOIgqHzVcpquJ87k7/x0b07iUHVpwClGfVAWQsuthBMpjhOS3ae2ty7pwD0e6P4LtTq5mgOHPvwOEbfY/NRm9N1D4gM1gAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E00E/uAD8AXUYbRhQtsECH8KBzPHZbx0jKhUUTyqSQ4=;
 b=MHIGinnLyjRWS/d/OtzNMJRc4y9RR8WmplNE1/IuOu+8ZQPd1pl1kLhjFiyGdigCjPh0uwWh347+qJdG0O06dYl6c/7x6v+Qrwqnr9BZkohdIv4Du/AHH6GA2BDDFZv5dMpi9J/H7C2a4NG9+nYBXDjM0P4vVGmD+vnkZLoUGS9bmO17mbqtrJGQDow0k53Bf7AeZ02btdxsi3bVYHzzmwJH2nw3pUNYYEbI1aE5C8NEU0yoRHf7BP5Zh7U/yXcONFyWc8PFMe4XkNG7QQvC7A1xlOmafk3a120emUh6YdDiPhpNQ4vUEmgvlsda7C2UdhA53bg1SWODkRAo6WH6eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6900.namprd11.prod.outlook.com (2603:10b6:806:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.15; Mon, 29 Sep
 2025 16:58:29 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 16:58:28 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v3 00/16] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCH v3 00/16] TDX: Enable Dynamic PAMT
Thread-Index: AQHcKPMxbI3n4d0yEEyHrd2rA1fcBLSkyKKAgADDrQCAAB+VAIAAAsIAgAAvCACAAgBqAIACNVcAgABVQQCAAAn0AA==
Date: Mon, 29 Sep 2025 16:58:27 +0000
Message-ID: <9f12fd82fec7fb4fa99ef51a4a80b9fe08c0001a.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <aNX6V6OSIwly1hu4@yzhao56-desk.sh.intel.com>
	 <8f772a23-ea7f-40eb-8852-49f5e3e16c15@intel.com>
	 <2b951e427c3f3f06fc310d151b7c9e960c32ec3f.camel@intel.com>
	 <7927271c-61e6-4f90-9127-c855a92fe766@intel.com>
	 <2fc6595ba9b2b3dc59a251fbac33daa73a107a92.camel@intel.com>
	 <aNiQlgY5fkz4mY0l@yzhao56-desk.sh.intel.com>
	 <x5wtf2whjjofaxufloomkebek4wnaiyjnteguanpw3ijdaer6q@daize5ngmfcl>
	 <0fc9a9ed-b0ba-45fc-8bd2-1bf24c14ab7f@intel.com>
In-Reply-To: <0fc9a9ed-b0ba-45fc-8bd2-1bf24c14ab7f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6900:EE_
x-ms-office365-filtering-correlation-id: 43156f2f-72e3-43b7-e771-08ddff796930
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Rmc2Uk9USUVLbkxMTVdwU0J0SlBRY0dMWmozU2R6TDRoTGVuNVJGMWhrbGJy?=
 =?utf-8?B?WkR1Y0NjOUlQbW8zSnhqSncraytxdjhhd0ovSFNvWUpmaWZSeGM4NTVqWTlN?=
 =?utf-8?B?K3h1T3YzbEJqVC9PbHBWNWMzK2FkUDYyMlJRSFZyU2g3aldlT0FEZ0Vjc3FR?=
 =?utf-8?B?RUZZNmJ5VXZDQmpUSWoyM0g1bGc3NmxsRXN0aUF3MTV4bHNIV1NJSzNZTTg1?=
 =?utf-8?B?QUJZeGd0NEp1R2RoaGk1bW1lSU9GRkRGRTdSbjM0S0JUeW9VZjEvaHFWSFVZ?=
 =?utf-8?B?em85aFZuOTZHWmd0RDRmTGozSGQrcE1odHR3RSsxelA3U0lUQ3UvZDYwdXVF?=
 =?utf-8?B?eWx5K05ZaGYrUVFGTTdWWXh5a0JXMlJTS2R1cnNJZEhMVFhhaFVmMDJNblEx?=
 =?utf-8?B?WnpoVTVGT0ZGWHZwRzBUZnJpaXZ4MFdkTzJkcmVzSk9FSmJBYlZlbkhSSmpz?=
 =?utf-8?B?ZlJwRXIrbjBQeWswREZRVm9aOStqTVFmZTg2MGNoZzczVTJ2MFhhR2NobmhP?=
 =?utf-8?B?djd4VTJnVFoybFhJeUxCVEJpc2dtSXRobFpwNHArQ0FFMkhoZjgxbUZUdmZ2?=
 =?utf-8?B?ei9OcmtEZ1FRKzJRRjhUcWlkSS9Ld0JTa3dseWhLb05JNUEyUm83ZlA2TWFS?=
 =?utf-8?B?QzhUOEtTdHV2UzEzVDM2QlZBdld2cHgxRTFUV3NFZzE3NVBCckhvS0p5TVhJ?=
 =?utf-8?B?dHBua3BGZUw1M20rSGc4ZmE4eDJNS3I0RlI2MVd6NjQ3a3kwZzRJQWcwQ05v?=
 =?utf-8?B?RERzUTJnTGJja3hvREJ1ZGZtbU51bEQ0d3Q3WjhBcVpPcGovQmhHNlFCNnZ3?=
 =?utf-8?B?anhNd1RucXBwVzdRY2xraHVXZWlWbFhHRjVtSy9ONzJSUm1WMUJDNzZadXAx?=
 =?utf-8?B?Q3BLSVhWais3WVN3RjdRdkltWE0zQTFsSXRSbmI2Q0FGQzNaSW5tY0FBNDE5?=
 =?utf-8?B?Nkg2SzYyZDJNTzViV2VTVGxJcXppYWcwWVNJZEpZZTdqbk9FaUxWMFZuVWNY?=
 =?utf-8?B?R3JDM3pUNXRZcEJMakdUb1VqMWRIKzY0cGY3N0Q2T0puRDA2VlFOQVppRkhY?=
 =?utf-8?B?empJR1FQcWI4V3ZGVmxxdHRURFdxd0dobTBKT0d5NURRTHRHcm5SZGdGVGk4?=
 =?utf-8?B?TjZKNGJTVmV0WjZlM1NVYjFyTkh4U3BtTTVKSC9JWW1sdUdXSFhqSmRURVdJ?=
 =?utf-8?B?SDU4L1lzQXl1ekRzOWlIRzhoOVA3VVpkSFMveTlCTXJ5UW9NNCtaRHVUQWNo?=
 =?utf-8?B?MzZ5SjNtZ1BUNk91cVJqbUEyMlFPSU1FZTZHQ0NBVzVDU0tEcUIxSEJzS2lj?=
 =?utf-8?B?cDQ1TjJVdWNoeWRiV2FaeXJ5WENOWmh0MlVENkpDS2hLVWhMMEhualFxNnJs?=
 =?utf-8?B?NndpWFBDNmJpRnhCTXpSRmVHN2ZjY0lqaG15L05LQnBaSXN1aDdZcTJ4eE15?=
 =?utf-8?B?bnRGcSt3Nys2QVJQUzRFRW50SFljUHBxNUNQNEVKbXYxVnNUaXZjYkRqbm43?=
 =?utf-8?B?RnZPaU9NdW9ZZ3l2VlZHZTExM1JhYlordHBuTzZweVZ3OHpLdTllVTNvN0cw?=
 =?utf-8?B?V3FzRG9tbkY5T3ZHUlpvdTJjL2hra2NBeXNIakpKM1dYamNzMkswRnRzTlMz?=
 =?utf-8?B?MmFPVThuYyt1MUhKdmdGZjhBUXA2R2Vqc3Vob3JEaVNqbFFQSEhGV2Z5MXBW?=
 =?utf-8?B?Q2hsV2pYR2JuMzBHZzFQZFBaVitLenR2TFFiRm9UUElsWGZtQVdBWGsvbG1I?=
 =?utf-8?B?V1NrM3J2NWhDcUFGTFlneEJiL0xrQmY3T1ljaFdpZ2lNTjVpTmN6NzdJR3pa?=
 =?utf-8?B?WTV2NjlrWmJ5UkdjSm5BcW5XNjU2TDBYeDdXSFdZMktPZUZzMGdCZ243Z2hw?=
 =?utf-8?B?ZlZLNzZxN2thTFVZVWQrYUpjS0VaQWxLMmFCZFhmSm9jOTdNMGdkMUdvN283?=
 =?utf-8?B?aERDM2xUVjNaSmJKd3JGWHc2YnBIaEhVQ0wwZ1lSOTFTeTYyU3FIYzlnRlR1?=
 =?utf-8?B?ZlMwZ1U3Sm05bi90K25oVk9sc1cyMHlvQ2FPcmF4bEFpUHhCYmVMU0pXanlT?=
 =?utf-8?Q?cXEUEK?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VS9KVmxDVENVRkRES2VaSHFXVTVTWnM2dnFiQTYwcG9aKzdrZnlSQVphaTBv?=
 =?utf-8?B?K2FSdTAvdzlwM2VUbHhFUldRTlB4STR5MEdvOFNPcm1JdDlTSThWYWU5amQ3?=
 =?utf-8?B?ZFZNTDZSaW5SZTJCQjl2eHRxY2pibFVldEZCbWFoRlpZSnNIbVV6OHNzRXQz?=
 =?utf-8?B?TWl4WEhQSDIyTU1zN01UUkNNamFUSk5CYzRxOHZ6dCtyU3hxLzR1YUxGdWgr?=
 =?utf-8?B?RW9kb204dmZ5SzhraDNRTVR2amdWUFV5VTNqanZkZWZTRGpueDQ5QmtIZUVX?=
 =?utf-8?B?a1ZtWWp4SEkzTDF2U3F4YzdSYUdWaDZUcDViaG5ib1NEd3lYb3FvRGtOU3c5?=
 =?utf-8?B?bHNzcnQ0NExkQUZvOE54cTZGckoyYVR1L21SNkMyM0Y2LzZtNXB5Q1I4NkJ5?=
 =?utf-8?B?RStLZjRoS3RCRzBLbW12NFBTZGs5RHpGRDFFdzBOYjFLR3N3VytFT1FCVDNS?=
 =?utf-8?B?dkt6MzhYMlZjOERwTDZ2MlZGQVFOK1lCRzhSdjFpWnJWZTlxZTVHaWRkbDBS?=
 =?utf-8?B?ekZ0VFEwUERhRmlDQ0hMVTZhS3ZXdGx0Y3ovRkU1dXlDMmd5WU1FcEJua1di?=
 =?utf-8?B?NGVUMHluSDFqcHk3SVhqUW9vY1dsOWxRclJONk10bGUzRWVHc2lPTVl1QnUz?=
 =?utf-8?B?ckdoYjNNaDNTOGZpaWc4KzZCVXE3VnVzSUMzd1hXRVF1VVpOK016eFY5YnRZ?=
 =?utf-8?B?dmR6bm5JanBFUi9IZ0JQc3dYU3AxOUo0eG4zTWQ1dnljTTM4WEF4MGdhMnp2?=
 =?utf-8?B?Y3ZNbjlpNU1TNUxPaTA3K0wvSS9vN1NkVGtUcWVHSjVQK1h3MWFKZXBRV0NS?=
 =?utf-8?B?V04zQ1FwSGl0MEN1S20rWjhwdzJPN2MrTTRGSUZ6MUhiQjZHY0x3bWlrZ3V6?=
 =?utf-8?B?T1hZcmJveXFNL1h6Nm54dmNBQ0gydWVYUWRtQzBEekFtZXRuK2VTdjV4ZHF3?=
 =?utf-8?B?VHZ4Z2JLeVdqUG9PWHgxN0RPMDZBWStjNVVlTjJZSENvOU1neGRSVzhzTUlv?=
 =?utf-8?B?QWpWdnJCQnRmNDZ0dFBKTjJpZHBMcm1KMjBVc3EvL29oNFZjbDZTREtpMTVG?=
 =?utf-8?B?V2EwQUdFMWdwM2FEajZEdm5vMGN3SXVkZ3pTcGVtRnZxRlNMQXFrdEFYRjhE?=
 =?utf-8?B?ZGFBVlBjSXplRTVMWWlYWHVhNnFkU01wd1ZIeWEwSWNnWUcwanFrR084OEZw?=
 =?utf-8?B?Ui9jeXZNYW1ZU1BoclpiK2ZGMThhTHhydHAwa2RWa3lXdjkzdXFMamZWQ0xk?=
 =?utf-8?B?SnFBWkRVQkFSdkNyVm9EdFJ2KzVzK21zdzFMcGxpUEptME9NSGJONTRpdldV?=
 =?utf-8?B?bUR1cTY4aUJPWUR5dmVXUFhJL2NpblFiWlJDb2EwWWtyclFZeVlGNFhBVmQ5?=
 =?utf-8?B?QnVZU002bnQ0UGllM1lRMURockh0cEhQcXJzTW9OT3J5UUhKMysxcFluM2xW?=
 =?utf-8?B?SkwvRmVNeldPeFhRVEdxa0pkSFQ2L1F2bnRsSWpWdEhNMHIrZ2FQUTE3Q2pl?=
 =?utf-8?B?ZEpYd3IxZUxKWUtzbnp0V0hEdmNJOXZQS1BiRitPVHNNYmwwU2l6VlJ5aTJh?=
 =?utf-8?B?VjZJQWJZSmtGbEJKeStMVk9CWnlPbm1sbmpXSHdjY2tCcldhekRQN3JoY056?=
 =?utf-8?B?VmU1MnYyRTNBRGh0UVF6N3FjV1JBYkRZc2c0SnJDM3daQU02eVQ0WVM3dzBP?=
 =?utf-8?B?NHpSOENxSzBVaFNJRmJvTmVmYlR3QnFzYllYQUt0cVMrbWxsMHBHZE1TMHJC?=
 =?utf-8?B?MEl5MW85SDNrZG5NME1WU0hNOTdMZ1QwNHhxUDgwazhCSFV6OGk3Q0FEMTdu?=
 =?utf-8?B?SVVPTTBZbEsxV3Z2dGVkTzkwZXpEUy96UkJhS2pPelRsYksxMzZIM3dxNkdm?=
 =?utf-8?B?TXhrRGY2c2dEVFZlMXRBSklTUTZyUDFDYlg1WnBCMENYN25qNUVJZWQxYitp?=
 =?utf-8?B?ei9wa1BHelNHM0xBcU8wWDU5WXNIc0g2VS83M0t4Sjh1NmwwYVkvUEIrK2dv?=
 =?utf-8?B?NTF1QVFhSUxkYnhQM3R3Q3dLTDF4RC9kRFZQeVQrdTVwOHNHVStwM1ZWZW5s?=
 =?utf-8?B?WXFpcUVNczE0NlZYbWYvMmNsYnJBM0YvWWlqSk1hUFB3d0xLNUxxOGFrZE81?=
 =?utf-8?B?bDNKTEZYNUhXd3BZUEduRkE2VSt2NnVZT1BmdjEzelgvQnJOQmFiN1lSSWVV?=
 =?utf-8?B?Smc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <22FD7A392B6C7D40AC5CF9484EF75660@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43156f2f-72e3-43b7-e771-08ddff796930
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2025 16:58:27.6801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hGf2QmwsnpawLFoi47T0vJFAwRAQGP2oYEXLxE/iRZvdhxyiNxeyZBJigqzOaNuwjGweTj7ujzhdFC4cR0YQzdHh78l39CxpHMW1gMHPWnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6900
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA5LTI5IGF0IDA5OjIyIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gOS8yOS8yNSAwNDoxNywgS2lyeWwgU2h1dHNlbWF1IHdyb3RlOg0KPiA+ID4gRG8geW91IGhh
dmUgYW55IHN1Z2dlc3Rpb25zIGZvciBhIGJldHRlciBhcHByb2FjaD8NCj4gPiA+IA0KPiA+ID4g
ZS5nLiwgY291bGQgdGhlIFBBTVQgcGFnZXMgYmUgYWxsb2NhdGVkIGZyb20gYSBkZWRpY2F0ZWQg
cG9vbCB0aGF0IGVuc3VyZXMgdGhleQ0KPiA+ID4gcmVzaWRlIGluIGRpZmZlcmVudCAyTUIgcmFu
Z2VzIGZyb20gZ3Vlc3QgcHJpdmF0ZSBwYWdlcyBhbmQgVEQgY29udHJvbCBwYWdlcz8NCg0KSSBn
dWVzcyB0aGUgVERYIG1vZHVsZSBjYW4gZ2V0IGF3YXkgd2l0aCBkb2luZyB0aGVtIGluIHdoYXRl
dmVyIHJhbmRvbSBvcmRlcg0KYmVjYXVzZSB0aGV5IGFyZSB0cnktbG9ja3MuIFBlcmhhcHMgd2Ug
Y291bGQgdGFrZSB0aGVtIGluIFBGTiBvcmRlcj8gSWYgbmVlZCBiZQ0KdGhlIFREWCBtb2R1bGUg
Y291bGQgZG8gdGhlIHNhbWUuDQoNCj4gPiBJdCBjYW4gd29yazogYWxsb2NhdGUgMk0gYSB0aW1l
IGZvciBQQU1UIGFuZCBwaWVjZW1lYWwgaXQgdG8gVERYIG1vZHVsZQ0KPiA+IGFzIG5lZWRlZC4g
QnV0IGl0IG1lYW5zIGlmIDJNIGFsbG9jYXRpb24gaXMgZmFpbGVkLCBURFggaXMgbm90IGZ1bmN0
aW9uYWwuDQo+ID4gDQo+ID4gTWF5YmUganVzdCB1c2UgYSBkZWRpY2F0ZWQga21lbV9jYWNoZSBm
b3IgUEFNVCBhbGxvY2F0aW9ucy4gQWx0aG91Z2gsIEkNCj4gPiBhbSBub3Qgc3VyZSBpZiB0aGVy
ZSdzIGEgd2F5IHRvIHNwZWNpZnkgdG8ga21lbV9jYWNoZSB3aGF0IHBhZ2VzIHRvIGFzaw0KPiA+
IGZyb20gcGFnZSBhbGxvY2F0b3IuDQo+IA0KPiBUaGF0IHNlZW1zIGEgYml0IG9idHVzZSByYXRo
ZXIgdGhhbiBqdXN0IHJlc3BlY3Rpbmcgbm9ybWFsIGxvY2sgb3JkZXJpbmcNCj4gcnVsZXMuIE5v
Pw0KDQpJdCBtaWdodCBzZXJ2ZSBhIHB1cnBvc2Ugb2YgcHJvdmluZyB0aGF0IHNjYWxhYmlsaXR5
IGlzIHBvc3NpYmxlLiBJIHdhcyB0aGlua2luZw0KaWYgd2UgaGFkIGxpbmUgb2Ygc2lnaHQgdG8g
aW1wcm92aW5nIGl0IHdlIGNvdWxkIGdvIHdpdGggdGhlICJzaW1wbGUiIHNvbHV0aW9uDQphbmQg
d2FpdCB1bnRpbCB0aGVyZSBpcyBhIHByb2JsZW0uIElzIGl0IHJlYXNvbmFibGU/DQoNCkJ1dCBs
b2NraW5nIGlzc3VlcyBhbmQgc3RhdGUgZHVwbGljYXRpb24gYmV0d2VlbiB0aGUgVERYIG1vZHVs
ZSBhbmQga2VybmVsIGFyZSBhDQpyZWN1cnJpbmcgcGF0dGVybi4gVGhlIHNpbWlsYXIgS1ZNIE1N
VSBpc3N1ZSB3YXMgcHJvYmFibHkgdGhlIG1vc3QgY29udGVudGlvdXMNCmRlc2lnbiBpc3N1ZSB3
ZSBoYWQgaW4gdGhlIFREWCBiYXNlIGVuYWJsaW5nIHRvZ2V0aGVyIHdpdGggdGhlIFREIGNvbmZp
Z3VyYXRpb24NCkFQSS4gVG8gbWUgRFBBTVQgaXMganVzdCBtb3JlIHByb29mIHRoYXQgdGhpcyBp
cyBub3QgYSByYXJlIGNvbmZsaWN0LCBidXQgYQ0KZnVuZGFtZW50YWwgcHJvYmxlbS4gSWYgd2Ug
ZG8gbmVlZCB0byBmaW5kIGEgd2F5IHRvIGltcHJvdmUgdGhlIERQQU1UDQpzY2FsYWJpbGl0eSwg
SSB3YW50IHRvIHNheSB3ZSBzaG91bGQgYWN0dWFsbHkgdGhpbmsgYWJvdXQgdGhlIGdlbmVyaWMg
Y2FzZSBhbmQNCnRyeSB0byBzb2x2ZSB0aGF0LiBCdXQgdGhhdCBuZWVkcyBtdWNoIG1vcmUgdGhv
dWdodC4uLg0K

