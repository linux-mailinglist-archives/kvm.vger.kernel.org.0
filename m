Return-Path: <kvm+bounces-64771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95FA8C8C3A5
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:33:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 449CF3AF6F1
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FAED342CBF;
	Wed, 26 Nov 2025 22:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XU8i4elw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36E82DC320;
	Wed, 26 Nov 2025 22:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764196395; cv=fail; b=hsUyXgCGybwtSI8ZowMrh+WHT8wjzdBbiK284ce4Vq8QFxI2exvBlsDHySFqChs/CIIO56XZp+Qn3qvQT9EosrkUUVYmdp5WztGwUXZkF6BzNSKTudQm5IafFNE1ZyOka7LkHrIWM6ORB8dzn3gxCPAOhvd62W88+0PvyziNdyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764196395; c=relaxed/simple;
	bh=KO7nchFymdxSd7f7x8Qr/V6r7k/o0B7znKweRQPDDHg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YuonEbVlnsCDONbTOa9MzuA/5d6u/2ra0dWFQ0BfX+3yQxoC6UI6qU7WQh1ZxH4bK8X0nabQWF99kzynG0PA2sgfthm+Z67hL9sOIDRyrX/9lK541g4REEDDn68lACueG/eLURgQ1lXa7KRNgm5FRF/W3cv+CZwkYjQEgBJQzc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XU8i4elw; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764196393; x=1795732393;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KO7nchFymdxSd7f7x8Qr/V6r7k/o0B7znKweRQPDDHg=;
  b=XU8i4elwdvJooKlvLdviVeO699b8qzcLZp2S5pCl7nNyXA3wVyECtiNh
   IWpQZcdOi2sZcclVdodiqbF53soqu4zL5drCcm/XxsMKwCJH06VeZlK2d
   zvdsYeuhjoN8yJyAarMUrGKAW9wx+512ywCghokSm7cg8bhdBQWPKQMra
   r1O0GknLs6STPYcJzWe7SblceIXrF43S3PL1JZg9ab/xVtYDVJ27FgIo+
   8G1IIV5PiW0+F1NGVnPOE8S9M0lTqgJoYiLCXr3XvoZqCAEHsf6lJQai+
   E/fHzPUHVKlrJTTLcImjeXy9FQgnMCcAXhhP0q/531git7fODpCv31fjF
   w==;
X-CSE-ConnectionGUID: +aPAXtz9RoGQJrLF3VBrgw==
X-CSE-MsgGUID: zp6S6J1cRsScPcnLDF0tOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="76931042"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="76931042"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:33:12 -0800
X-CSE-ConnectionGUID: L8y0y7zXSYawiyZpRSly5Q==
X-CSE-MsgGUID: EwZwZSqPQHOb55X+Cbz/7Q==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:33:12 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 14:33:11 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 14:33:11 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.28) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 14:33:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TSWEHe3VVaX7X5eoh1gCZSmb6gluqAEJ1OSnCyNr+Nmek6kIjB+Ob9zV+djU3cdzx22TUp8R2nrVBJkJWBBSdAfy5TUetxNJu3Py9EoxWMcRxy1Qpg6A0wqmgaQt7cjiuvzMdhxrXmwReH/vdal5dg/NrzRkvXrwRokzP0YdO8unLPtCWqEkrGNY5GIdIMwIRQ3jeS8ma9izcOIz7HaKjA1gTVRCvBxGfqZ4cPSu5+GvJt5ici45r/BJX8vKcnVApY5XYdWZVcNLfyJHyfvH46TAYd25ktEjVcNii748VaAZq1wHEvJNGojXr5nYTJR586jw6pV79psDL3zeRT//qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KO7nchFymdxSd7f7x8Qr/V6r7k/o0B7znKweRQPDDHg=;
 b=dtX31z5DbmnRpb61geSUUTznyshHIp1TNiWVdxKgpw9jkDNg/uYhuhVZC29wVNQtTGNT3DNs0DkrvOHCrlU7cDnXvPAi5WKXUWMti7lM65oSywJnIc+GyzbG/nrbmt+7m2lW0MwT3OSfgtUsSA3D7uamox/K35W0FUNFg5jvwODg3I82yzOuPpCHrx564WwkLHhXIBa41+UfUcX1KxSBtnsez8RhbM7uvV+ygqPHZv9F8+1DkMWnLb7m+L98DFUr779y0bomYWnxXgaU20mMHEfK+t2PaXWXPVV1P71qcV88KqjjmbMhAx+icdetjVFkd4poazsnJiamfM1UpJVqUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH3PPF5AF05F6D9.namprd11.prod.outlook.com (2603:10b6:518:1::d24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 22:33:08 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 22:33:08 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v4 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Topic: [PATCH v4 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Index: AQHcWoELLxf19qpVqUu0bWQO50RjlbUEV7eAgAE8jIA=
Date: Wed, 26 Nov 2025 22:33:08 +0000
Message-ID: <af0e05e39229adb814601eb9ce720a0278be3c2f.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-13-rick.p.edgecombe@intel.com>
	 <7a6f5b4e-ad7b-4ad0-95fd-e1698f9b4e06@linux.intel.com>
In-Reply-To: <7a6f5b4e-ad7b-4ad0-95fd-e1698f9b4e06@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH3PPF5AF05F6D9:EE_
x-ms-office365-filtering-correlation-id: 4b5136cc-7a81-471b-4220-08de2d3bc615
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?V01NOHZTb0x6cXRWR01iSVRJTlhiMXora3h1WmQ4S2FDMXJaZWZEMWk0S0pj?=
 =?utf-8?B?VlkxZTZXU2JxVDBUbHd2c1dDOFI1ZUt1UW1TcGFGZWJjaGg2M1RaQTBnc2ti?=
 =?utf-8?B?d2Zkc1hzd3NMckJrOTBMS3dnZlRvUTE1NlZEK0ZJNHJ2YTJQTFFkekxkY2g4?=
 =?utf-8?B?dE9zQVphVlZ1VERZMWlyejNpZkpEaWk2cFM3LzBTVE5YWU9pSlZHY1Z3eG5I?=
 =?utf-8?B?MHM2MUNOQU96aVU5MW5hdGExUFpjVjR5Nkx2dldHcUVISTlQbGJjdGRtTUZN?=
 =?utf-8?B?QlBWMVIzRExHTXpiQWIvVERzNnhJUC9ya3ZzN1NRQ2FtdDFRa3ppaHYvenYy?=
 =?utf-8?B?NjZDQm12ZWRDdE9VMkkvZURhVDg3ZkVNb2lLTHBBN0M0dmZvRVY0VjhyZUNa?=
 =?utf-8?B?Q3VLK3hSc0ZCbWRtWnZtQkhZT3dSWEU3MXhtZllXWWc4NWVlUDVCcGl0dFhl?=
 =?utf-8?B?WG9XL09pK3BJa3gwNHRROWZhUk82QnN2R3FoeWhMVkdERkZrZmVKQzJTV1pC?=
 =?utf-8?B?RmxvWFZsNnZIMXpYL0NVZlMvZFdNZkZPWUVKQ2gwOVMxcHJRRmxVZ0M2RmlS?=
 =?utf-8?B?dWJMd2ZjNFNZUy9vbjVXd0w5MDUvRkx5NlA3L3NtblNIalVvSzBWand4QjVF?=
 =?utf-8?B?eVJGM00xSlJlclFidVQyWlFvYWJyaElOVDN5UHV1b09ndG5mZUZCdEE4bGtP?=
 =?utf-8?B?OUVpdFU4UFJoK3lTMUNjQVdjMEtER1ZZdWZvSVB1NUtiMU9NUnh5em5pTnMz?=
 =?utf-8?B?ZmVvREgrSkE2TndkNCtQM2pBb3lsZXpDdUVUR3JqYzE2RjhrTktjVEJ0TkY2?=
 =?utf-8?B?RDNZaTBudWRVNXVUMUxCREJUbFlJdURiRXpVUzBva1YzVVFLOTY2aHBka21p?=
 =?utf-8?B?ZVI4VGx0TGFDR1luQWFpYWFmTXVKck92Z3VrcFM2WlBSWU01VEx4SWwzS1Mv?=
 =?utf-8?B?VWdjUkkweHBsTHg2L0NYWWErdHJDK1JYZmJ3bnFVRlZIOG1WY2ZZeDJJUG56?=
 =?utf-8?B?Uy9aQ0NISUpiM0laRDRHWnFaSTVId2lZaTVKa1gzMFQvbkR4R0xKV2RqaW1z?=
 =?utf-8?B?c1J1SllpN1BiVmVxdklKZEpvaUlhdnhBYVpzL1diak9XcW4xc1A5YnlMZlR2?=
 =?utf-8?B?UWRlakF1UytWU3FxZlgzeGx4V1VCQXhYSm40TDZNRHh6NHJqZVRuUStGZFFS?=
 =?utf-8?B?dm5CL1FmTHYxQlkzazZnZVMzS3VoRmd4QThxSGxQdUpqZHdLRklZSVUrNkQ3?=
 =?utf-8?B?UWEwZlgyRWxkR0hJNnIwUzZKRGcyTVBQK3B1elArQnM2QmxaWDBMd3FsUzZw?=
 =?utf-8?B?bXpoUE05bzZvczRTNkY4Y1BTbGp3eU5ndlIvL2dHZFlrWWd6ZkxBbDczdERO?=
 =?utf-8?B?dVFKYXNlVU1VRGdWNFpyUFdhOVlOUE0ydHlDWUUrcEw0MWlSRnVPbndabGQx?=
 =?utf-8?B?RktRei9nTFFLY0drQWhxVm5CalVIeitNb3o0YlFaUFRwVmgzcTJZc3QxS1da?=
 =?utf-8?B?YUxUU01UTUNLQjNKZHpEbmNLdnhwTStkaWVmTVpyZmE4MEJBeXJSQ3pxR3RI?=
 =?utf-8?B?SGthL25kYlk0VGRqeEx5cEVFcE5yaTVMd1FOM3M0bVVsUHRkK1lOdkRyaG1I?=
 =?utf-8?B?b3ZQSytlcEZMdEFnMDFTODRrRlBVREpKWndlWS9sYmoybUZ3N0x5dUdVa1RI?=
 =?utf-8?B?eVhUQU5vQ0ZjZDVxRUtWVDJ3MWVLUFhva2g3OTRweTdDam1zZkpFRmk5RjNX?=
 =?utf-8?B?eFpNcE9DSUlGMzBFbXlRb01INU5uL1M5aTVLdHBMS3FURlV1YjlnalVMSlA5?=
 =?utf-8?B?dWkxSEs5SUE2MCtRZm4yRnpYcTBPTlorU3NBTlJlbnlwR0dzbk1rYVJFOXpp?=
 =?utf-8?B?L21FY3hGakhRV0p3VWZFcTdkb2tyb3FyQnBtVEdFc1VKTjAzVUdvcURwbjRa?=
 =?utf-8?B?K2hUN1lpK2FSSERERnlLaDBIend2dVc4ZEZDUG91Wk5LZmFjR3RxdlZRbGNp?=
 =?utf-8?B?ZllMZWNJK01YR0NpcTVCZnZ5N3o5MFpaU3BxRCtsb3M2MzRCVlU4aEk1RC9q?=
 =?utf-8?Q?M1fY/L?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVFWaW9teFh6eEVnMG8vU2F5QWlGK1BpNXZZcmZ1SjcvY1BPWjBtdUdYcGVQ?=
 =?utf-8?B?Q0J5VGpXUzRzb1NrczQ3SkRndnVaTU9yMlJkMC9VU0RwaGlIT1ZiRTE3MVlC?=
 =?utf-8?B?SWlya1JYeUFOWEpMZzMwYlRWWVJsV2w5MUR3M1pIYjcvK0hldENIUmQrcUV6?=
 =?utf-8?B?eGJ6TkZyYmhWbEo5NDc5TUJhRGZvd1JBa1B5SWlRcjU4ZGtOVjEydllZWHJk?=
 =?utf-8?B?SnhLYmQ0WFowRGpOQzgxVU82empZZHV2cVh2WGxadmZZck9FNFhNN1hEQ0I5?=
 =?utf-8?B?U0hTMHdRTlI3UW4wNVNKTUNVQmhaWmtoQ3dvTlNVRHVhT1lzN1J4OWpieGcv?=
 =?utf-8?B?YitOTjJwQlZydlQ5YTBwODZWaHNhYWJiT0pDQ1NnZlM2ZWRQZVVOUkI4dlpW?=
 =?utf-8?B?NVZ0RU8zVEVEbDRJQm5JemhlNWlWYVdIQ1JVVmx3TU9jWGlZSU1LMlloT0Zt?=
 =?utf-8?B?dlBaZHVWOTFlZlVLMTR2RVptT0RCSFoxNmVJUTJQRWJtSFR5dnVjMGxFQnVS?=
 =?utf-8?B?MmpNZVRWcWw3TDZaZlp0b2NLV3ZWZWJkVmxKaWo3NHJyaVlWKzNPT0g0MlJ1?=
 =?utf-8?B?cmZkc2krTWZiMlY3TTZvaStxNEVrcFRlbXpEdlZ1c09HRGY0NjBuMmo2R0hJ?=
 =?utf-8?B?R2R1eE9DSlVob1hmR3pGbHA0aTk1UVViRHl4UytsWXBoTy9kOSt3eXFXUlBY?=
 =?utf-8?B?aENES25PYWJlVFNZdjF6UjQ4M0JlTlJvTmlYVC8vQVdENjdlZUxJWTZvSVZT?=
 =?utf-8?B?ZWxESm9qa2tZSUw1UjVlSFBjbGN0TzlzOWRRRytDYVprdVlnZldGb1lxZEVO?=
 =?utf-8?B?R2ZDcFNsQjBlVlpsMFVYVktISW9XdHZNZTRoeEs5RWRhaTlkek5sQkZySll3?=
 =?utf-8?B?bEtNemJBMWpIWXRSZVBCUDhpRzVyZjhmdnh6U2xualBLdVRCbzd0dlc0T252?=
 =?utf-8?B?azJNTEk4Y21EdGVGd3c2ak01Q05oMmYwRVFPcTAyUGRQcGNtMmV6REtqbHl6?=
 =?utf-8?B?NytvY29OTW9NQ0RNd1VOa0FCL3pZaG9meUJueDZ5UDVFcGZWcTlqQWUxTFFk?=
 =?utf-8?B?b0VjbDhnbk5XS1hDR0xzUFE3QS9BZWUybkNUZTFqSWkvOHpadjZmeU9IQVJR?=
 =?utf-8?B?cDRKUytVZjhnUHhtYXY3NVBCRGFFMFlSemZMSkxwODVoWXVPZHNSMUJxRzFu?=
 =?utf-8?B?SjZEdkZtbG9TS3VZUk5Za3llKyt2YjNUMk9jcGFtc3g4L1dtMG4wNzlXTzVa?=
 =?utf-8?B?YUtmczNzOUdnWG12c3lxZTdCZTU2S2U2b2tGdzJsOXBPTlpucitPcWJLdWNj?=
 =?utf-8?B?T3JTcnF3S3RQU0s4TFhRcWxDQmdzTWZhUnVYcUdIMEVMeklOOVprZWRMNDhx?=
 =?utf-8?B?b0hnU1dzYUNGWDBwSDB1RlBFQ1NtR1ZiKzNsVjc2M3JvVG9mWExGeFBMUU8w?=
 =?utf-8?B?aHFXeFVlTnIvZDZzREFlQ3hSazlLeGRESW9IN0F0cHViNG9PQjB6VlVaQmpr?=
 =?utf-8?B?SWxiYng5T2phZ053TlNieGkzQ1lNOCt0dmJoZVNWaW9zc09Fd3VXbXVsSjdJ?=
 =?utf-8?B?d0YyN1F0SUs3dmtieFkxYmVDblA4Q1dFMDNiRE9abU01Y3ZDdERHdkx4WWRP?=
 =?utf-8?B?R3FXVXB1OElDZ1hBbDJKTWRqUkFPaFBuejUvbm81dmJlOW0xMFgzM3JRMkx4?=
 =?utf-8?B?eVBKR2JFeStZeVhrZkQrN1ZkR3BXanA4Z085eXEvSlhqZUhEbnZxN0xxRU9a?=
 =?utf-8?B?NFBIOXcvZktLbUFNaFgwaWFGSTJFRVFoc0U3QXdkVkxaWnNhQS9senMvMUZY?=
 =?utf-8?B?dm45Y0h5U3g3dDZCdFJhNnpZdlVMTFFMQUsxMUxqMnVDNGdUT0RVbkZqVXEx?=
 =?utf-8?B?MnIwb000Ri9Pc0ZEaWJZREVaZy83OTVOZHdUYlZKbVM0d0tWRHlmL3VuQ2VR?=
 =?utf-8?B?Y29WVHNOZ3JrdkJ4RmpHc3A3bUdTV3Z4Vk40OXRoYm5POHc3MnpBZVBKRmtQ?=
 =?utf-8?B?cWJOTDAvVXVFZ0NtYXZ5RmZQRWtJNGQ4ZTN2TXFvT1lDSlNvQk1YM2FsN3Mv?=
 =?utf-8?B?WWhpRE5qQmFwL2gzSHREQld4RjljeUM2WVp4bTJuVmduZTN1MjdGbmFTUTY4?=
 =?utf-8?B?TE9JVjZBc1JCR1JZUXRSK01kREp3akhhaS9TSXBHeUp1Q1hIc0xWSFhkMHg2?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDAC937D8A737D488E351E873E5B7001@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b5136cc-7a81-471b-4220-08de2d3bc615
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 22:33:08.2363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hN9IRTWURLGoGnqYssD2pQ2ytnnX3Z5DCNIB3uptZl3HZhI/aEXak/kGVKjpeJeyO5BKEZPeJPM/QE99bkhaIMw+UkWXvi/axANObFuKhyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF5AF05F6D9
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTExLTI2IGF0IDExOjQwICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IA0K
PiBPbiAxMS8yMS8yMDI1IDg6NTEgQU0sIFJpY2sgRWRnZWNvbWJlIHdyb3RlOg0KPiA+IEluIHRo
ZSBLVk0gZmF1bHQgcGF0aCBwYWdlLCB0YWJsZXMgYW5kIHByaXZhdGUgcGFnZXMgbmVlZCB0byBi
ZQ0KPiAiSW4gdGhlIEtWTSBmYXVsdCBwYXRoIHBhZ2UsIHRhYmxlcyAuLi4iIHNob3VsZCBiZQ0K
PiAiSW4gdGhlIEtWTSBmYXVsdCBwYXRoLCBwYWdlIHRhYmxlcyAuLi4iDQoNClJpZ2h0LCB0aGFu
a3MuDQoNCj4gDQo+ID4gaW5zdGFsbGVkIHVuZGVyIGEgc3BpbiBsb2NrLiBUaGlzIG1lYW5zIHRo
YXQgdGhlIG9wZXJhdGlvbnMgYXJvdW5kDQo+ID4gaW5zdGFsbGluZyBQQU1UIHBhZ2VzIGZvciB0
aGVtIHdpbGwgbm90IGJlIGFibGUgdG8gYWxsb2NhdGUgcGFnZXMuDQo+ID4gDQo+IFsuLi5dDQo+
ID4gQEAgLTE0MSw3ICsxNDIsNDYgQEAgaW50IHRkeF9ndWVzdF9rZXlpZF9hbGxvYyh2b2lkKTsN
Cj4gPiDCoMKgIHUzMiB0ZHhfZ2V0X25yX2d1ZXN0X2tleWlkcyh2b2lkKTsNCj4gPiDCoMKgIHZv
aWQgdGR4X2d1ZXN0X2tleWlkX2ZyZWUodW5zaWduZWQgaW50IGtleWlkKTsNCj4gPiDCoMKgIA0K
PiA+IC1pbnQgdGR4X3BhbXRfZ2V0KHN0cnVjdCBwYWdlICpwYWdlKTsNCj4gPiAraW50IHRkeF9k
cGFtdF9lbnRyeV9wYWdlcyh2b2lkKTsNCj4gPiArDQo+ID4gKy8qDQo+ID4gKyAqIFNpbXBsZSBz
dHJ1Y3R1cmUgZm9yIHByZS1hbGxvY2F0aW5nIER5bmFtaWMNCj4gPiArICogUEFNVCBwYWdlcyBv
dXRzaWRlIG9mIGxvY2tzLg0KPiANCj4gSXQncyBub3QganVzdCBmb3IgRHluYW1pYyBQQU1UIHBh
Z2VzLCBidXQgYWxzbyBleHRlcm5hbCBwYWdlIHRhYmxlIHBhZ2VzLg0KDQpJJ2xsIGFkanVzdC4N
Cg0KPiANCj4gPiArICovDQo+ID4gK3N0cnVjdCB0ZHhfcHJlYWxsb2Mgew0KPiA+ICsJc3RydWN0
IGxpc3RfaGVhZCBwYWdlX2xpc3Q7DQo+ID4gKwlpbnQgY250Ow0KPiA+ICt9Ow0KPiA+ICsNCj4g
PiArc3RhdGljIGlubGluZSBzdHJ1Y3QgcGFnZSAqZ2V0X3RkeF9wcmVhbGxvY19wYWdlKHN0cnVj
dCB0ZHhfcHJlYWxsb2MgKnByZWFsbG9jKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgcGFnZSAqcGFn
ZTsNCj4gPiArDQo+ID4gKwlwYWdlID0gbGlzdF9maXJzdF9lbnRyeV9vcl9udWxsKCZwcmVhbGxv
Yy0+cGFnZV9saXN0LCBzdHJ1Y3QgcGFnZSwgbHJ1KTsNCj4gPiArCWlmIChwYWdlKSB7DQo+ID4g
KwkJbGlzdF9kZWwoJnBhZ2UtPmxydSk7DQo+ID4gKwkJcHJlYWxsb2MtPmNudC0tOw0KPiA+ICsJ
fQ0KPiA+ICsNCj4gPiArCXJldHVybiBwYWdlOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMg
aW5saW5lIGludCB0b3B1cF90ZHhfcHJlYWxsb2NfcGFnZShzdHJ1Y3QgdGR4X3ByZWFsbG9jICpw
cmVhbGxvYywgdW5zaWduZWQgaW50IG1pbl9zaXplKQ0KPiA+ICt7DQo+ID4gKwl3aGlsZSAocHJl
YWxsb2MtPmNudCA8IG1pbl9zaXplKSB7DQo+ID4gKwkJc3RydWN0IHBhZ2UgKnBhZ2UgPSBhbGxv
Y19wYWdlKEdGUF9LRVJORUxfQUNDT1VOVCk7DQo+ID4gKw0KPiA+ICsJCWlmICghcGFnZSkNCj4g
PiArCQkJcmV0dXJuIC1FTk9NRU07DQo+ID4gKw0KPiA+ICsJCWxpc3RfYWRkKCZwYWdlLT5scnUs
ICZwcmVhbGxvYy0+cGFnZV9saXN0KTsNCj4gPiArCQlwcmVhbGxvYy0+Y250Kys7DQo+ID4gKwl9
DQo+ID4gKw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4gPiArDQo+ID4gK2ludCB0ZHhfcGFt
dF9nZXQoc3RydWN0IHBhZ2UgKnBhZ2UsIHN0cnVjdCB0ZHhfcHJlYWxsb2MgKnByZWFsbG9jKTsN
Cj4gPiDCoMKgIHZvaWQgdGR4X3BhbXRfcHV0KHN0cnVjdCBwYWdlICpwYWdlKTsNCj4gPiDCoMKg
IA0KPiA+IMKgwqAgc3RydWN0IHBhZ2UgKnRkeF9hbGxvY19wYWdlKHZvaWQpOw0KPiA+IEBAIC0y
MTksNiArMjU5LDcgQEAgc3RhdGljIGlubGluZSBpbnQgdGR4X2VuYWJsZSh2b2lkKcKgIHsgcmV0
dXJuIC1FTk9ERVY7IH0NCj4gPiDCoMKgIHN0YXRpYyBpbmxpbmUgdTMyIHRkeF9nZXRfbnJfZ3Vl
c3Rfa2V5aWRzKHZvaWQpIHsgcmV0dXJuIDA7IH0NCj4gPiDCoMKgIHN0YXRpYyBpbmxpbmUgY29u
c3QgY2hhciAqdGR4X2R1bXBfbWNlX2luZm8oc3RydWN0IG1jZSAqbSkgeyByZXR1cm4gTlVMTDsg
fQ0KPiA+IMKgwqAgc3RhdGljIGlubGluZSBjb25zdCBzdHJ1Y3QgdGR4X3N5c19pbmZvICp0ZHhf
Z2V0X3N5c2luZm8odm9pZCkgeyByZXR1cm4gTlVMTDsgfQ0KPiA+ICtzdGF0aWMgaW5saW5lIGlu
dCB0ZHhfZHBhbXRfZW50cnlfcGFnZXModm9pZCkgeyByZXR1cm4gMDsgfQ0KPiA+IMKgwqAgI2Vu
ZGlmCS8qIENPTkZJR19JTlRFTF9URFhfSE9TVCAqLw0KPiA+IMKgwqAgDQo+ID4gwqDCoCAjaWZk
ZWYgQ09ORklHX0tFWEVDX0NPUkUNCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90
ZHguYyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gPiBpbmRleCAyNjBiYjBlNmViNDQuLjYx
YTA1OGE4ZjE1OSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ID4g
KysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiA+IEBAIC0xNjQ0LDIzICsxNjQ0LDM0IEBA
IHN0YXRpYyBpbnQgdGR4X21lbV9wYWdlX2FkZChzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwg
ZW51bSBwZ19sZXZlbCBsZXZlbCwNCj4gPiDCoMKgIA0KPiA+IMKgwqAgc3RhdGljIHZvaWQgKnRk
eF9hbGxvY19leHRlcm5hbF9mYXVsdF9jYWNoZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4g
wqDCoCB7DQo+ID4gLQlzdHJ1Y3QgdmNwdV90ZHggKnRkeCA9IHRvX3RkeCh2Y3B1KTsNCj4gPiAr
CXN0cnVjdCBwYWdlICpwYWdlID0gZ2V0X3RkeF9wcmVhbGxvY19wYWdlKCZ0b190ZHgodmNwdSkt
PnByZWFsbG9jKTsNCj4gPiDCoMKgIA0KPiA+IC0JcmV0dXJuIGt2bV9tbXVfbWVtb3J5X2NhY2hl
X2FsbG9jKCZ0ZHgtPm1tdV9leHRlcm5hbF9zcHRfY2FjaGUpOw0KPiA+ICsJaWYgKFdBUk5fT05f
T05DRSghcGFnZSkpDQo+ID4gKwkJcmV0dXJuICh2b2lkICopX19nZXRfZnJlZV9wYWdlKEdGUF9B
VE9NSUMgfCBfX0dGUF9BQ0NPVU5UKTsNCj4gDQo+IGt2bV9tbXVfbWVtb3J5X2NhY2hlX2FsbG9j
KCkgY2FsbHMgQlVHX09OKCkgaWYgdGhlIGF0b21pYyBhbGxvY2F0aW9uIGZhaWxlZC4NCj4gRG8g
d2Ugd2FudCB0byBmb2xsb3c/DQoNCklnbm9yaW5nLCBwZXIgeW91ciBvdGhlciBjb21tZW50LiBC
dXQgd2UgZG9uJ3Qgd2FudCB0byBhZGQgQlVHX09OKClzIGluIGdlbmVyYWwuDQo+IA0KPiA+ICsN
Cj4gPiArCXJldHVybiBwYWdlX2FkZHJlc3MocGFnZSk7DQo+ID4gwqDCoCB9DQo+ID4gwqDCoCAN
Cj4gPiDCoMKgIHN0YXRpYyBpbnQgdGR4X3RvcHVwX2V4dGVybmFsX2ZhdWx0X2NhY2hlKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSwgdW5zaWduZWQgaW50IGNudCkNCj4gPiDCoMKgIHsNCj4gPiAtCXN0
cnVjdCB2Y3B1X3RkeCAqdGR4ID0gdG9fdGR4KHZjcHUpOw0KPiA+ICsJc3RydWN0IHRkeF9wcmVh
bGxvYyAqcHJlYWxsb2MgPSAmdG9fdGR4KHZjcHUpLT5wcmVhbGxvYzsNCj4gPiArCWludCBtaW5f
ZmF1bHRfY2FjaGVfc2l6ZTsNCj4gPiDCoMKgIA0KPiA+IC0JcmV0dXJuIGt2bV9tbXVfdG9wdXBf
bWVtb3J5X2NhY2hlKCZ0ZHgtPm1tdV9leHRlcm5hbF9zcHRfY2FjaGUsIGNudCk7DQo+ID4gKwkv
KiBFeHRlcm5hbCBwYWdlIHRhYmxlcyAqLw0KPiA+ICsJbWluX2ZhdWx0X2NhY2hlX3NpemUgPSBj
bnQ7DQo+ID4gKwkvKiBEeW5hbWljIFBBTVQgcGFnZXMgKGlmIGVuYWJsZWQpICovDQo+ID4gKwlt
aW5fZmF1bHRfY2FjaGVfc2l6ZSArPSB0ZHhfZHBhbXRfZW50cnlfcGFnZXMoKSAqIFBUNjRfUk9P
VF9NQVhfTEVWRUw7DQo+IA0KPiBJcyB0aGUgdmFsdWUgUFQ2NF9ST09UX01BWF9MRVZFTCBpbnRl
bmRlZCwgc2luY2UgZHluYW1pYyBQQU1UIHBhZ2VzIGFyZSBvbmx5DQo+IG5lZWRlZCBmb3IgNEtC
IGxldmVsPw0KDQpJJ20gbm90IHN1cmUgSSBmb2xsb3cuIFdlIG5lZWQgRFBBTVQgYmFja2luZyBm
b3IgZWFjaCBTLUVQVCBwYWdlIHRhYmxlLg0K

