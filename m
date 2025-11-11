Return-Path: <kvm+bounces-62762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46162C4D561
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 12:12:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 754B03A7A94
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 11:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D8A350A06;
	Tue, 11 Nov 2025 11:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OTeuCG5K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D865633F396;
	Tue, 11 Nov 2025 11:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762859135; cv=fail; b=gurvgRXTJbsP2K1hV9exyD/SzsaoyXUtbKzC5/pZsmrrDucus2Yd5eJAf5VjosIW6gLH8rz3hR7kxzr8hRebgi7bKY1RTYVImg8lmkJon0j61TMtiOMb0VsYQsICuDCW0ERe6q/RNSBLiC+LCs6ffnhOm7fvfsA7xz7GsB+lEUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762859135; c=relaxed/simple;
	bh=JRWYl/Ypfu96OUEoLjAToV8mz0xIeOhNdPTQ9tP+MhE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nUpbw6HlHhUutm/sLbDA6xh3pODDrbyx1ke1SS7f/7oVi2HvCbKswxJ4ajmMkgGcfr5oM+DOsWGc/UnAP/uATDANxEk56aB043kwQJKEL1RBB761YAMdD75CIQjakQe6G8At4K4IK0CEM0Z89s9OAFo04z+L33hV/Tn6AuvtQL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OTeuCG5K; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762859134; x=1794395134;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JRWYl/Ypfu96OUEoLjAToV8mz0xIeOhNdPTQ9tP+MhE=;
  b=OTeuCG5KVrTyErGbGVQmldfSiKKRsrDBsFUXkEMEao4n/PXlEwVWfhBl
   kN7ZIwXt56OasRDZ5elbxDdc7ia7yB45pbR86XdZ9xAlEKoRDtxm1o3kC
   9d+LtsqYwNMU6PV42X0NnzLDw04SvER1mva+3xmIEwdN3ZNuYO9RpO2Un
   ZL0EnM2HEMAfRsqgICphxWyyxgaBlAgt5O8b6s1wo8Sn8kH/3SYLeylB0
   4A7fRhqZsHnQ0ROhZy6MzvgqxDtc5Yn8EPQNobUGBmyzLAF3b6RgKlNk3
   aw4rQ0nHyQv00rx25ilGa4fqLmiQHdQwtex8BZE4ZJB3e/AbjiIk8j0jY
   Q==;
X-CSE-ConnectionGUID: 9dfh+5MxSly9IMhQ+8j9yQ==
X-CSE-MsgGUID: TZb4bSwBTLebMQ951lR90w==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="67523382"
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="67523382"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 03:05:33 -0800
X-CSE-ConnectionGUID: 29SbAu69S+Kw2Agx6faefA==
X-CSE-MsgGUID: is4UlTI5ScyDuyvTHnBmbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="188256399"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 03:05:32 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 03:05:32 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 03:05:31 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.6) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 03:05:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=STOFXFb9wuPCiugvo16snOQ1EEeDuiN/vBq0GgVdBKGr78w9/YZ6GkthTPFGXy0fFNG0c8BgLTL8Z3n+46Vy3L7r9NNZoQ1IdSwbRi9IX6CK3bSq2AlP/Cg6KdfjkoY4C4FGFCipz6Yx+qnJmIWrlVW5OrtNkuqUENrDQ1WxJVVc55nBN3zZiLsPkQ+QIySR0RyAdFqZ8tfXIvwhEk47Gu55dEE4TQHpd/krZd1C/sVbbTWrV8JCVRVZ28jqrpujBdyw+kWrkhcALReDrWpUeEcZYTbxdhwkq0Uni5xXLgW+FhvWvMEf4ZONvS6DENzG2pnpFQz1wEVWucKWXO983g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JRWYl/Ypfu96OUEoLjAToV8mz0xIeOhNdPTQ9tP+MhE=;
 b=dn8EK7GjesysXYpXPtHUa7bzMAfnOo8aRF+BPbcbwtaixnXN7Bpn2+0W9NlCQoDtiwpYsXLcHzK/Tf9wmBWcuwOpXy083vuypuP8Hy9XX4zxKIQlOjo7tcmBz4cH4qQgc+HNfN/5Rs86/F08u3Gj/dvMWZ7nw4Vx9TV0I9eVyeinO5UHrXsxcQaB99BSjcFRZxWgI2M4SI+abAr3o7VFqnx0AZ0oQ1FWGiKw/2s8hDE3qXhmiBuI+SZrgzBwP0aDsGY2b3XRFYQqlnMmBGqplur2IRRvQXMQwqZBQgpO1Nq+DI7lWnVvRUWJxjmAZzLhlYBCdkIvtxeaa/aYLMxDYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM4PR11MB6501.namprd11.prod.outlook.com (2603:10b6:8:88::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.16; Tue, 11 Nov 2025 11:05:29 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Tue, 11 Nov 2025
 11:05:28 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "zhiquan1.li@intel.com"
	<zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "pgonda@google.com"
	<pgonda@google.com>
Subject: Re: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings if
 a VMExit carries level info
Thread-Topic: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings
 if a VMExit carries level info
Thread-Index: AQHcB4ATc43XQ6PqxUuwXAgCtykiwLTt5ymA
Date: Tue, 11 Nov 2025 11:05:28 +0000
Message-ID: <5e1461b8e2ece1647b0d26f0c3b89e98d232bfd0.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094423.4644-1-yan.y.zhao@intel.com>
In-Reply-To: <20250807094423.4644-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM4PR11MB6501:EE_
x-ms-office365-filtering-correlation-id: 635b0b1e-8e1e-4a0b-d887-08de21123900
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cE5hR1FyamRGeUdmU1kzNFl2VmtiQmtmV2VnMFVpbkZ1WGVEYnRsRnY2ZVVI?=
 =?utf-8?B?OWN6bmV3TGQ0ZTdQZjAwRloyUXlya05pSnVVSkFGYnRpOExFN1JIWm1Ybm5v?=
 =?utf-8?B?Z1RLNmg5ZUtUVmhVM2dhR1VwclRFak1WbmlDdDVpYVVEdWlMWm5QVVd1MDUz?=
 =?utf-8?B?OUh4Y1pjbFRxQktIVHVBMmdJMXNtTHlDL0RlQk5oTXE1S0w1VWc3ZjduUWZj?=
 =?utf-8?B?bkxLMjNnSHVwWHVlSDVidkx5M0VRNWY1Zk9KQTNCcnFrNUNhNCsyS0cycWk1?=
 =?utf-8?B?QldLQjFIRjR6VE9jNDYvK0R1Sk4xSldvejZYWi9vSzJBbGVoY3NsbXlMOFNx?=
 =?utf-8?B?WWRYMjRueHVDOHNzNExSSlRkbnBwbDlDMkxvKzJ0M2Z2YTVqK1dML2huYVVo?=
 =?utf-8?B?MWFNU3FRRXVUU0ZiNVJTbWJmNnFEMk1yNkZNdHF0MUJTSXhvcnJvSnJxZWwz?=
 =?utf-8?B?QjlGTHpRV1dya05wR2srcHZyZVlmaUNPekdJdFFoU0xLU1EwUC9EZTBHQkx6?=
 =?utf-8?B?ZnliM2pKQXhiWEc1VjlpU2xOTlduWWd4R3gxWkpyNzR0MHdtUzEwN2k0MGsy?=
 =?utf-8?B?eWNBYWY3QkxYOTNqRzV4cmg2R1JITk04U2xHRnZHSmpuRUJxVXVPNEk1TnhL?=
 =?utf-8?B?RWlPbnU4Tm5nOE9uNUtZU3Z6RGhIbS8zN1o0NFQ3b2NlLzl1cFI3Y2VKdElW?=
 =?utf-8?B?M1ZnMHZqSmdKZDdBSnZrYStFRGFhdDdubDZjYlp6cmx0amR3R0xZWEtqUWVu?=
 =?utf-8?B?dGdqeExhRGxCT2ZBcDJSV1RvRklDbnRBMFNpejk3RDN4WGk2TDQzdGwvWCtB?=
 =?utf-8?B?YTY1cEFCRlZSYlRLd3BPaTJtTnZTQTZJL25QcndiOG05Vzh6VnkyWTVOZzZE?=
 =?utf-8?B?MFI4dU9pd0c2V09WTnNWMFV5TE85dWxYVXd3N2FYeStvc0w5ajBNTTF5ajFm?=
 =?utf-8?B?VUhYaFNrR1ZuL0JSaCtRSHNiUGhJVkdHV0RKWGh4L2hYdE9qOGlqeHgyblYx?=
 =?utf-8?B?bkxhbE9Vb2ZuNy9UK1dmK042cTF2ZklkcU1zUzcrUkVYQ0VwL3V6aXZyUmdy?=
 =?utf-8?B?NjRXOWMxM1EvZlQyMzZySk1JOGlKRDh4RTVtdjkvZ1g2UEFRSkcvQmdkcmQy?=
 =?utf-8?B?eVNqNWExSno4aUIvUVFaeHU2VFYyTWxhTVFpbFZaNE5TSGJCZ3h3cE53QU5r?=
 =?utf-8?B?aTI2NTlIK1hlK203ZEtYRnVlS2JaZ1lkVFdGenB3d3V0Y0t3cGo1eUlCQlhx?=
 =?utf-8?B?dXpZYjRmOXdYOHBtUkJUNHJrUVgrdmYxbmhrbDVPc0grZjdFbnJJZkJSTEhB?=
 =?utf-8?B?WFN1V1Vza1YrbENhZ1d1blpwak1NdjFITjBkWmkyYUtiQUFmYzdSZkpJWjRZ?=
 =?utf-8?B?SXBqc3VZcXVzaVhCdmRLSngwWWNBaFhMZDV0YlZQWElIazNTSGZjc2NCOGhs?=
 =?utf-8?B?UFh5TjltY3FIeFhHa1I4ODQrbmQ2c2lNdHd4bjhiWEh0bkdaOUNWTnBpSXlr?=
 =?utf-8?B?OEMzWWhuOThIK2xNalZvTFQ0eHVQUXl1NDRFNGhUbmQ1NlUydU5DVzgyNE5y?=
 =?utf-8?B?ODljWFp3S0xsQnZrS0hIclRSRFNRNFVDL1NJMkNZK2t3VTg3TEhQdmxZQjBD?=
 =?utf-8?B?aTlscC90ZHJRNXhKcVB4RmZxTERLK1ZCMHZMK0dRSVI2SUtxZHBGN091a1dy?=
 =?utf-8?B?eXgwaTA0ZHMvTUpaMEhDSmVwR1Zsb3dnblJCTXVDZ2tXbjJSOFpYWVFSTDU4?=
 =?utf-8?B?UU1CdHZxNmRsU0gzWHd5djd6cS9vdnNqUFZhMm5SM1h4WXZrem00b1J3b2xE?=
 =?utf-8?B?MEp1WXBBQlVmNzJMNitXQWNnem9NUjBhV1NQeVhPSEtMR01mSVhuRUxZdjF6?=
 =?utf-8?B?RlJxcFVtTThMRndNM3N3eDhBZlpFaGNtVFl2bFNmZlZpWm0zZnd2ZGJXRVgv?=
 =?utf-8?B?c3E5dkpaVE00N3VDTzhxMDM5MHBGLzVHd0xRenJ0aGFrcVFzdTljcWczbysr?=
 =?utf-8?B?c0FpazJmR1BuUlh2TFRrRjhjRnBDcTYrUndXMzROWDg2MldwQzVuRWdhamxW?=
 =?utf-8?Q?GXQolX?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UE9oNHk0cE5qaGJ0TEZGeGE5bE5BR3prOUVDa1FNbVBOVWptMmNlSGNPd256?=
 =?utf-8?B?Q2FGTWVjWUF0N2dKdWlsVmdIMlB0cTFxU1lKbkVUajFseXlORlF1bEtYeG1X?=
 =?utf-8?B?bE5NakZYZUdIeXpISGFuMk9hRU9xNTNQcUJQa0NMbFhhdXdjckdKMC9rTWVt?=
 =?utf-8?B?NEtBRkVhWmxkbkV3dWdOY3hhY3Jna05ray96RWVEQ29wUWltazVJMXJ3b0Nu?=
 =?utf-8?B?WGxMcWRlcmJRVjR1TWNkWHk4eHZnNVJNNmpzTnBWNGVZMHBWWGpTSjQ1eEFL?=
 =?utf-8?B?cWVSZFZBeGZtQ0s1UG8rR3dhTFlGcWlYalJCR0w1eVNsM1FxRTN0QU9oK0dK?=
 =?utf-8?B?bDJSYnNTRVhJZCt5WG52c2VMc1ZqekQybElHamdaQUJrQVNFZWhIcHNIRVcz?=
 =?utf-8?B?OWRTbDNINzdJb0wzc2pqSDIwdFhaYWhpTU9tYmhNNm4zZU5NSURtdGx3WVpo?=
 =?utf-8?B?aW8vQkI2MkZ3alhCaWRYVTNLYkVEcGp5UnkxdUErejJGMDFlT3BwSHJyVjBE?=
 =?utf-8?B?cElnSHVIblhyU2pWY0V3d00vUXFtUVhFeFVxQXdRb0NBZmJJNmQwdTlvZzF0?=
 =?utf-8?B?NkVSQjhQeDJHbC90QWdpL0ZiVUdzazdLV3BSaTFqUks5Q0dCVEZ2YWRRcEI4?=
 =?utf-8?B?eVZGRjhqSEN2R1ZZRHNXRUNWVUNTeEdqM3JlN1V5enBmcHlFVWdOWXRaeEgz?=
 =?utf-8?B?OWdQTEc4alpuUlpXckk3TElreEMzSE02alROa1hEd2JIeDlqSnluZ3pPUXpX?=
 =?utf-8?B?VDdlNTRBQ3RqRmFrOTRoT21JNlhzcDFzckdMcWxpbVA2ck9UcUNJUWlPcDdO?=
 =?utf-8?B?Q29xUzFxVWRkSlRvVVJtUjhRTTR2WEZ1Ym1QeW9aQk4xM1dObzFGM0lRRGRr?=
 =?utf-8?B?SFRBaVRJU3h2RGFoMlM4eDcvMktGVkxiRHBaa1dvTnBTQWJnQ3dMcHpQdWNz?=
 =?utf-8?B?YUgwcnVEdEliUXhRQmJaQURCQ0hoSUZlZFh1ck1yYWNCcXdSZ21EUkYzd2Iz?=
 =?utf-8?B?UkhIUXFqdXkzMzkxRWdSazlyTm1ibHh0MFB1OWZXaU52MlNLdG8zNDlVYUJS?=
 =?utf-8?B?SlRHTnNhcDJwNEZ0VVA4MjNVR3E2U1ozTWUrUFVEc1htRkp0YzJjNlZCTWVK?=
 =?utf-8?B?cUVTMDRheWQ5d3JmNXNkbnJ2Z0ZacVNDZUVhVWIrOVRZb25rdkxnWXFremhS?=
 =?utf-8?B?RkFRa2JjTHgwYmkrdmFRSTdNQjdCUERVUVc0SlA1T2dRSEZYWVJKU3VNK1hG?=
 =?utf-8?B?MkRrV3pqdnRxZkhjR0krOXZCNzd6QituQ0dySEpoM2VkU1htUW1EZHQrdHZF?=
 =?utf-8?B?cytRamkxUVBNSTJxdUxNMWpzaXNXOGxjSWZ0aWduQVhYbkIrSWNFMUUyb05N?=
 =?utf-8?B?U3h4ZTlKaFZCdURZVzRqS250ZG5LQUYvdWxNRFhaQndpUGFLS0tGUmdrdUl6?=
 =?utf-8?B?Y2t3M1MrZjdqVzFremsxU3RvdU5TalZUM2JmL1BnWmtsN0R0WTRLSWtLOER5?=
 =?utf-8?B?VHBmeHpjTkhTVFIzcmR3R0pnbDVFK2NiUDFJaGhuQWFIUUErOVZtdlZ2ajcr?=
 =?utf-8?B?azV3YWtnSGVuSExtdHpZV2FZakhmSEdjNGlNQ1NzcU9sVkJCQStkNmF2Znpt?=
 =?utf-8?B?ODlhVlhJb2RudUI1ek1scmVseSs0YU9MSWc1Z3dMbkhFQU8veWlCQXZKT0pT?=
 =?utf-8?B?Yk1CK05GcG5qNkx1U0N5WE1wdkJXT21QZUVOTUR4TEZzYWdiN1lsRjFWVE9H?=
 =?utf-8?B?amJrTHhGNkpYemdyNUoyNjhrUW5neGVCUkJmYTJmdkpncDRaSHMzQ0FrbFpN?=
 =?utf-8?B?SjdmNU0rakc0QU96eUdxYnNDaWtDQjJCREwwc3VwcHFtU1FoMnkyUmgzYWtO?=
 =?utf-8?B?QlgzVUVwbFc3NFA0YnVncS84SUhmYkxFZmJrZURRbVlBb0FjSHZ6RHpkS3lP?=
 =?utf-8?B?ODd5dmNkMStQdHZORDZBK1R6WFdvcUxpaGZsOVBub0VNd2ZkYkZicXBKOGMz?=
 =?utf-8?B?Q2ZtZTBOV0syUk83aU1XeGxLMjQydng4a3oyREFZam5GZGtQeWcwbFdGOS85?=
 =?utf-8?B?NFhxNjVzbXlrc1FCSEUxTFNud2ZCaFU2bWJCejFpalR1Zk9GdmlEZGdnbkwx?=
 =?utf-8?Q?KHHz6HXph1GR2Lnik8QAC6fBY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD1FC9EC9823AB4988D28BA92019DDF9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 635b0b1e-8e1e-4a0b-d887-08de21123900
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2025 11:05:28.2363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UxhyA+KcBXevjow0TR9v8Y2CUhI6JkcErzzTi/eIDeF+nRAaRkuYsEilK/iLuQzTWmWdld6TagsNubIirp8FDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6501
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTA3IGF0IDE3OjQ0ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gVERY
IHJlcXVpcmVzIGd1ZXN0cyB0byBhY2NlcHQgUy1FUFQgbWFwcGluZ3MgY3JlYXRlZCBieSB0aGUg
aG9zdCBLVk0uIER1ZQ0KPiB0byB0aGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiBvZiB0aGUgVERY
IG1vZHVsZSwgaWYgYSBndWVzdCBhY2NlcHRzIGEgR0ZODQo+IGF0IGEgbG93ZXIgbGV2ZWwgYWZ0
ZXIgS1ZNIG1hcHMgaXQgYXQgYSBoaWdoZXIgbGV2ZWwsIHRoZSBURFggbW9kdWxlIHdpbGwNCj4g
ZW11bGF0ZSBhbiBFUFQgdmlvbGF0aW9uIFZNRXhpdCB0byBLVk0gaW5zdGVhZCBvZiByZXR1cm5p
bmcgYSBzaXplIG1pc21hdGNoDQo+IGVycm9yIHRvIHRoZSBndWVzdC4gSWYgS1ZNIGZhaWxzIHRv
IHBlcmZvcm0gcGFnZSBzcGxpdHRpbmcgaW4gdGhlIFZNRXhpdA0KPiBoYW5kbGVyLCB0aGUgZ3Vl
c3QncyBhY2NlcHQgb3BlcmF0aW9uIHdpbGwgYmUgdHJpZ2dlcmVkIGFnYWluIHVwb24NCj4gcmUt
ZW50ZXJpbmcgdGhlIGd1ZXN0LCBjYXVzaW5nIGEgcmVwZWF0ZWQgRVBUIHZpb2xhdGlvbiBWTUV4
aXQuDQo+IA0KPiBUaGUgVERYIG1vZHVsZSB0aHVzIGVuYWJsZXMgdGhlIEVQVCB2aW9sYXRpb24g
Vk1FeGl0IHRvIGNhcnJ5IHRoZSBndWVzdCdzDQo+IGFjY2VwdCBsZXZlbCB3aGVuIHRoZSBWTUV4
aXQgaXMgY2F1c2VkIGJ5IHRoZSBndWVzdCdzIGFjY2VwdCBvcGVyYXRpb24uDQo+IA0KPiBUaGVy
ZWZvcmUsIGluIFREWCdzIEVQVCB2aW9sYXRpb24gaGFuZGxlcg0KPiAoMSkgU2V0IHRoZSBndWVz
dCBpbmhpYml0IGJpdCBpbiB0aGUgbHBhZ2UgaW5mbyB0byBwcmV2ZW50IEtWTSBNTVUgY29yZQ0K
PiAgICAgZnJvbSBtYXBwaW5nIGF0IGEgaGlnaGVyIGEgbGV2ZWwgdGhhbiB0aGUgZ3Vlc3QncyBh
Y2NlcHQgbGV2ZWwuDQo+IA0KPiAoMikgU3BsaXQgYW55IGV4aXN0aW5nIGh1Z2UgbWFwcGluZyBh
dCB0aGUgZmF1bHQgR0ZOIHRvIGF2b2lkIHVuc3VwcG9ydGVkDQo+ICAgICBzcGxpdHRpbmcgdW5k
ZXIgdGhlIHNoYXJlZCBtbXVfbG9jayBieSBURFguDQo+IA0KPiBVc2Ugd3JpdGUgbW11X2xvY2sg
dG8gcHJldGVjdCAoMSkgYW5kICgyKSBmb3Igbm93LiBJZiBmdXR1cmUgS1ZNIFREWCBjYW4NCj4g
cGVyZm9ybSB0aGUgYWN0dWFsIHNwbGl0dGluZyB1bmRlciBzaGFyZWQgbW11X2xvY2sgd2l0aCBl
bmhhbmNlZCBURFgNCj4gbW9kdWxlcywgKDEpIGlzIHBvc3NpYmxlIHRvIGJlIGNhbGxlZCB1bmRl
ciBzaGFyZWQgbW11X2xvY2ssIGFuZCAoMikgd291bGQNCj4gYmVjb21lIHVubmVjZXNzYXJ5Lg0K
PiANCj4gQXMgYW4gb3B0aW1pemF0aW9uLCB0aGlzIHBhdGNoIGNhbGxzIGh1Z2VwYWdlX3Rlc3Rf
Z3Vlc3RfaW5oaWJpdCgpIHdpdGhvdXQNCj4gaG9sZGluZyB0aGUgbW11X2xvY2sgdG8gcmVkdWNl
IHRoZSBmcmVxdWVuY3kgb2YgYWNxdWlyaW5nIHRoZSB3cml0ZQ0KPiBtbXVfbG9jay4gVGhlIHdy
aXRlIG1tdV9sb2NrIGlzIHRodXMgb25seSBhY3F1aXJlZCBpZiB0aGUgZ3Vlc3QgaW5oaWJpdCBi
aXQNCj4gaXMgbm90IGFscmVhZHkgc2V0LiBUaGlzIGlzIHNhZmUgYmVjYXVzZSB0aGUgZ3Vlc3Qg
aW5oaWJpdCBiaXQgaXMgc2V0IGluIGENCj4gb25lLXdheSBtYW5uZXIgd2hpbGUgdGhlIHNwbGl0
dGluZyB1bmRlciB0aGUgd3JpdGUgbW11X2xvY2sgaXMgcGVyZm9ybWVkDQo+IGJlZm9yZSBzZXR0
aW5nIHRoZSBndWVzdCBpbmhpYml0IGJpdC4NCj4gDQo+IExpbms6IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2FsbC9hNmZmZTIzZmI5N2U2NDEwOWY1MTJmYTQzZTlmNjQwNTIzNmVkNDBhLmNhbWVs
QGludGVsLmNvbQ0KPiBTdWdnZXN0ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNv
bWJlQGludGVsLmNvbT4NCj4gU3VnZ2VzdGVkLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFu
amNAZ29vZ2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWWFuIFpoYW8gPHlhbi55LnpoYW9AaW50
ZWwuY29tPg0KPiAtLS0NCj4gUkZDIHYyDQo+IC0gQ2hhbmdlIHRkeF9nZXRfYWNjZXB0X2xldmVs
KCkgdG8gdGR4X2NoZWNrX2FjY2VwdF9sZXZlbCgpLg0KPiAtIEludm9rZSBrdm1fc3BsaXRfY3Jv
c3NfYm91bmRhcnlfbGVhZnMoKSBhbmQgaHVnZXBhZ2Vfc2V0X2d1ZXN0X2luaGliaXQoKQ0KPiAg
IHRvIGNoYW5nZSBLVk0gbWFwcGluZyBsZXZlbCBpbiBhIGdsb2JhbCB3YXkgYWNjb3JkaW5nIHRv
IGd1ZXN0IGFjY2VwdA0KPiAgIGxldmVsLiAoUmljaywgU2VhbikuDQo+IA0KPiBSRkMgdjE6DQo+
IC0gSW50cm9kdWNlIHRkeF9nZXRfYWNjZXB0X2xldmVsKCkgdG8gZ2V0IGd1ZXN0IGFjY2VwdCBs
ZXZlbC4NCj4gLSBVc2UgdGR4LT52aW9sYXRpb25fcmVxdWVzdF9sZXZlbCBhbmQgdGR4LT52aW9s
YXRpb25fZ2ZuKiB0byBwYXNzIGd1ZXN0DQo+ICAgYWNjZXB0IGxldmVsIHRvIHRkeF9nbWVtX3By
aXZhdGVfbWF4X21hcHBpbmdfbGV2ZWwoKSB0byBkZXRlbWluZSBLVk0NCj4gICBtYXBwaW5nIGxl
dmVsLg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS92bXgvdGR4LmMgICAgICB8IDUwICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gIGFyY2gveDg2L2t2bS92bXgvdGR4X2Fy
Y2guaCB8ICAzICsrKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA1MyBpbnNlcnRpb25zKCspDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gveDg2L2t2bS92bXgv
dGR4LmMNCj4gaW5kZXggMDM1ZDgxMjc1YmU0Li43MTExNTA1OGU1ZTYgMTAwNjQ0DQo+IC0tLSBh
L2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0K
PiBAQCAtMjAxOSw2ICsyMDE5LDUzIEBAIHN0YXRpYyBpbmxpbmUgYm9vbCB0ZHhfaXNfc2VwdF92
aW9sYXRpb25fdW5leHBlY3RlZF9wZW5kaW5nKHN0cnVjdCBrdm1fdmNwdSAqdmNwDQo+ICAJcmV0
dXJuICEoZXEgJiBFUFRfVklPTEFUSU9OX1BST1RfTUFTSykgJiYgIShlcSAmIEVQVF9WSU9MQVRJ
T05fRVhFQ19GT1JfUklORzNfTElOKTsNCj4gIH0NCj4gIA0KPiArc3RhdGljIGlubGluZSBpbnQg
dGR4X2NoZWNrX2FjY2VwdF9sZXZlbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGdmbl90IGdmbikN
Cj4gK3sNCj4gKwlzdHJ1Y3Qga3ZtX21lbW9yeV9zbG90ICpzbG90ID0gZ2ZuX3RvX21lbXNsb3Qo
dmNwdS0+a3ZtLCBnZm4pOw0KPiArCXN0cnVjdCB2Y3B1X3RkeCAqdGR4ID0gdG9fdGR4KHZjcHUp
Ow0KPiArCXN0cnVjdCBrdm0gKmt2bSA9IHZjcHUtPmt2bTsNCj4gKwl1NjQgZWVxX3R5cGUsIGVl
cV9pbmZvOw0KPiArCWludCBsZXZlbCA9IC0xOw0KPiArDQo+ICsJaWYgKCFzbG90KQ0KPiArCQly
ZXR1cm4gMDsNCj4gKw0KPiArCWVlcV90eXBlID0gdGR4LT5leHRfZXhpdF9xdWFsaWZpY2F0aW9u
ICYgVERYX0VYVF9FWElUX1FVQUxfVFlQRV9NQVNLOw0KPiArCWlmIChlZXFfdHlwZSAhPSBURFhf
RVhUX0VYSVRfUVVBTF9UWVBFX0FDQ0VQVCkNCj4gKwkJcmV0dXJuIDA7DQo+ICsNCj4gKwllZXFf
aW5mbyA9ICh0ZHgtPmV4dF9leGl0X3F1YWxpZmljYXRpb24gJiBURFhfRVhUX0VYSVRfUVVBTF9J
TkZPX01BU0spID4+DQo+ICsJCSAgIFREWF9FWFRfRVhJVF9RVUFMX0lORk9fU0hJRlQ7DQo+ICsN
Cj4gKwlsZXZlbCA9IChlZXFfaW5mbyAmIEdFTk1BU0soMiwgMCkpICsgMTsNCj4gKw0KPiArCWlm
IChsZXZlbCA9PSBQR19MRVZFTF80SyB8fCBsZXZlbCA9PSBQR19MRVZFTF8yTSkgew0KPiArCQlp
ZiAoIWh1Z2VwYWdlX3Rlc3RfZ3Vlc3RfaW5oaWJpdChzbG90LCBnZm4sIGxldmVsICsgMSkpIHsN
Cj4gKwkJCWdmbl90IGJhc2VfZ2ZuID0gZ2ZuX3JvdW5kX2Zvcl9sZXZlbChnZm4sIGxldmVsKTsN
Cj4gKwkJCXN0cnVjdCBrdm1fZ2ZuX3JhbmdlIGdmbl9yYW5nZSA9IHsNCj4gKwkJCQkuc3RhcnQg
PSBiYXNlX2dmbiwNCj4gKwkJCQkuZW5kID0gYmFzZV9nZm4gKyBLVk1fUEFHRVNfUEVSX0hQQUdF
KGxldmVsKSwNCj4gKwkJCQkuc2xvdCA9IHNsb3QsDQo+ICsJCQkJLm1heV9ibG9jayA9IHRydWUs
DQo+ICsJCQkJLmF0dHJfZmlsdGVyID0gS1ZNX0ZJTFRFUl9QUklWQVRFLA0KPiArCQkJfTsNCj4g
Kw0KPiArCQkJc2NvcGVkX2d1YXJkKHdyaXRlX2xvY2ssICZrdm0tPm1tdV9sb2NrKSB7DQo+ICsJ
CQkJaW50IHJldDsNCj4gKw0KPiArCQkJCXJldCA9IGt2bV9zcGxpdF9jcm9zc19ib3VuZGFyeV9s
ZWFmcyhrdm0sICZnZm5fcmFuZ2UsIGZhbHNlKTsNCj4gKwkJCQlpZiAocmV0KQ0KPiArCQkJCQly
ZXR1cm4gcmV0Ow0KPiArDQo+ICsJCQkJaHVnZXBhZ2Vfc2V0X2d1ZXN0X2luaGliaXQoc2xvdCwg
Z2ZuLCBsZXZlbCArIDEpOw0KPiArCQkJCWlmIChsZXZlbCA9PSBQR19MRVZFTF80SykNCj4gKwkJ
CQkJaHVnZXBhZ2Vfc2V0X2d1ZXN0X2luaGliaXQoc2xvdCwgZ2ZuLCBsZXZlbCArIDIpOw0KPiAr
CQkJfQ0KPiArCQl9DQo+ICsJfQ0KDQpBbHNvLCBjb3VsZCB5b3UgYWxzbyBjbGFyaWZ5IHdoYXQn
cyB0aGUgY3VycmVudCBiZWhhdmlvdXIgd2hlbiB0aGUgZXhpdA0KZG9lc24ndCBoYXZlIGFueSBs
ZXZlbCBpbmZvcm1hdGlvbj8NCg0KV2lsbCAnbGV2ZWwgPT0gUEdfTEVWRUxfNEsnIGluIHRoaXMg
Y2FzZT8gIE9yIHdpbGwgdGhpcyBmdW5jdGlvbiByZXR1cm4NCmVhcmx5IHJpZ2h0IGFmdGVyIGNo
ZWNrIHRoZSBlZXFfdHlwZT8NCg0KSXQncyBub3QgbWVudGlvbmVkIGFueXdoZXJlIGluIHRoZSBj
aGFuZ2Vsb2cuICBUaGUgY292ZXIgbGV0dGVyIHZhZ3VlbHkNCnNheXM6DQoNCiAgVGhpcyBtZWNo
YW5pc20gYWxsb3dzIHN1cHBvcnQgb2YgaHVnZSBwYWdlcyBmb3Igbm9uLUxpbnV4IFREcyBhbmQN
CiAgYWxzbyByZW1vdmVzIHRoZSA0S0IgcmVzdHJpY3Rpb24gb24gcHJlLWZhdWx0IG1hcHBpbmdz
IGZvciBMaW51eA0KICBURHMgaW4gUkZDIHYxLg0KDQpCdXQgaXQncyBub3QgY2xlYXIgdG8gbWUg
aG93IHRoaXMgaXMgc29sdmVkLg0K

